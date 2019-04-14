//
//  AddToPlaylistViewController.swift
//  smore
//
//  Created by Jing Wei Li on 4/11/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import Photos

class AddToPlaylistViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var addPlaylistImageButton: UIButton!
    
    let viewModel: AddToPlaylistViewModel
    
    init(viewModel: AddToPlaylistViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AddToPlaylistViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        doneButton.addRoundCorners(cornerRadius: 10)
        playlistImageView.addRoundCorners()
        cancelButton.addSmoreBoder()
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [
                .font: UIFont(name: "AvenirNext-Bold", size: 17.0)!,
                .foregroundColor: UIColor.lightGray
            ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.applyContentSize()
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: "Add a name for the playlist")
            return
        }
        var description: String?
        
        if descriptionTextView.text.isEmpty || descriptionTextView.text == "description" {
            description = nil
        } else {
            description = descriptionTextView.text
        }
        if viewModel.imageURL == nil { viewModel.imageURL = viewModel.songToAdd.imageLink }
        let playlist = CombinedPlaylist(name: name, imageLink: viewModel.imageURL,
                                        description: description, songs: [viewModel.songToAdd])
        PlaylistEntity.makePlaylist(with: playlist)
        view.addSubview(LottieActivityIndicator.checkmark)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPlaylistImageButtonTapped(_ sender: Any) {
        viewModel.requestPhotoAuthAndPresentImagePicker { [weak self] in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helpers
    func applyContentSize(keyboardHeight: CGFloat = 0) {
        let fixedHeight: CGFloat = 600
        let tableViewContentSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: CGFloat(viewModel.existingPlaylists.count) * SearchTableViewCell.preferredHeight)
        tableView.contentSize = tableViewContentSize
        tableViewHeight.constant = tableViewContentSize.height
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: fixedHeight + keyboardHeight + tableViewContentSize.height)
        view.layoutIfNeeded()
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        guard let info = notification.userInfo else { return }
        guard let frameInfo = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = frameInfo.cgRectValue
        applyContentSize(keyboardHeight: keyboardFrame.height)
    }
}

extension AddToPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.existingPlaylists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,
                                                 for: indexPath)
        
        let playlist = viewModel.existingPlaylists[indexPath.row]
        if let cell = cell as? SearchTableViewCell {
            if let url = playlist.imageLink, url.absoluteString.starts(with: "assets-library") {
                let width = UIScreen.main.bounds.width * 0.2 * UIScreen.main.scale
                cell.masterImage.setImageWithAssetURL(url, size: CGSize(width: width, height: width))
            } else {
                cell.masterImage.kf.setImage(with: playlist.imageLink,
                                             placeholder: UIImage(named: "artistPlaceholder"))
            }
            cell.masterLabel.text = playlist.name
            cell.subtitleLabel.text = playlist.curatorName
            cell.serviceIcon.image = playlist.streamingService.icon
            cell.masterImage.addRoundCorners(cornerRadius: 10)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = viewModel.existingPlaylists[indexPath.row]
        if let error = PlaylistEntity.add(song: viewModel.songToAdd, to: playlist) {
            SwiftMessagesWrapper.showErrorMessage(title: "Error", body: error.localizedDescription)
        } else {
            view.addSubview(LottieActivityIndicator.checkmark)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}

extension AddToPlaylistViewController: UIScrollViewDelegate {
    
}

extension AddToPlaylistViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        descriptionTextView.becomeFirstResponder()
        return false
    }
}

extension AddToPlaylistViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String) -> Bool
    {
        if text.last == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "description" { textView.text = "" }
    }
}

extension AddToPlaylistViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            playlistImageView.image = pickedImage
            addPlaylistImageButton.isHidden = true
        }
        
        if let refURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            viewModel.imageURL = refURL
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddToPlaylistViewController: UINavigationControllerDelegate { }
