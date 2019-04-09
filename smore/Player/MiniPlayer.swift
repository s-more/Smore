//
//  MiniPlayer.swift
//  smore
//
//  Created by Jing Wei Li on 3/16/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import MarqueeLabel
import Kingfisher

class MiniPlayer: UIView {
    @IBOutlet weak var visualFxView: UIVisualEffectView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var songTitle: MarqueeLabel!
    @IBOutlet weak var subTitle: MarqueeLabel!
    @IBOutlet weak var playButton: UIButton!
    
    private let miniPlayerHeight: CGFloat = 60
    
    static var tabBarHeight: CGFloat = 60
    static let shared = MiniPlayer()
    var playerVCToPresent: PlayerViewController?
    
    var isShown = false
    private let originalFrame: CGRect

    private init() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            originalFrame = CGRect(
                x: 0,
                y: UIScreen.main.bounds.height - MiniPlayer.tabBarHeight - miniPlayerHeight,
                width: UIScreen.main.bounds.width,
                height: miniPlayerHeight)
        } else { // ipads
            let screenHeight = UIScreen.main.bounds.height
            originalFrame = CGRect(
                x: 0,
                y: screenHeight - (screenHeight - 667)/2 - MiniPlayer.tabBarHeight - miniPlayerHeight,
                width: 667, // ipads use iphone apps in a 4.7 inch screen size
                height: miniPlayerHeight)
            print(originalFrame)
        }
        super.init(frame: originalFrame)
        Bundle.main.loadNibNamed("MiniPlayer", owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        clipsToBounds = true
        thumbnail.addRoundCorners(cornerRadius: 5.0)
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.5
        
        visualFxView.prepareForAutolayout()
        addSubview(visualFxView)
        thumbnail.prepareForAutolayout()
        addSubview(thumbnail)
        songTitle.prepareForAutolayout()
        addSubview(songTitle)
        subTitle.prepareForAutolayout()
        addSubview(subTitle)
        playButton.prepareForAutolayout()
        addSubview(playButton)
        alpha = 0
    }
    
    func configure(with song: Song) {
        if !isShown {
            isShown = true
            alpha = 0
            isHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.alpha = 1
            }
        }
        Player.shared.state = .playing
        playButton.setImage(PlayerState.playing.image, for: .normal)
        songTitle.text = song.name + " "
        subTitle.text = song.artistName + " "
        thumbnail.kf.setImage(with: song.imageLink, placeholder: UIImage(named: "artistPlayholder"))
    }
    
    func reset() {
        thumbnail.image = UIImage(named: "artistPlaceholder")
        subTitle.text = ""
        songTitle.text = "Not Playing"
        playButton.setImage(PlayerState.notPlaying.image, for: .normal)
    }
    
    func updatePlayIconImage() {
        playButton.setImage(Player.shared.state.image, for: .normal)
    }
    
    func resetLocation() {
        frame = originalFrame
    }
    
    // MARK: - IBActions
    
    @IBAction func playOrPause(_ sender: UIButton) {
        Player.shared.playOrPause()
        playButton.setImage(Player.shared.state.image, for: .normal)
    }
    
    @IBAction func panned(_ sender: UIPanGestureRecognizer) {
        frame.origin = CGPoint(x: 0, y: sender.location(in: superview).y)
        let translation = sender.translation(in: superview).y
        
        switch sender.state {
        case .ended:
            if translation < 0 {
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: [.curveEaseIn],
                               animations:
                { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.frame.origin = CGPoint(x: 0, y: -60)
                }, completion: nil)
                let vc = PlayerViewController()
                (window?.rootViewController as? TabBarViewController)?.present(vc, animated: true)
                Haptic.current.beep()
            } else {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.frame = strongSelf.originalFrame
                    }, completion: nil)
            }
        default: break
        }
    }
    
}

private extension UIView {
    func prepareForAutolayout() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        translatesAutoresizingMaskIntoConstraints = true
    }
}
