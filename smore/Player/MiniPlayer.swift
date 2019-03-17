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
    
    var isShown = false

    private init() {
        super.init(frame: CGRect(
            x: 0,
            y: UIScreen.main.bounds.height - MiniPlayer.tabBarHeight - miniPlayerHeight,
            width: UIScreen.main.bounds.width,
            height: miniPlayerHeight))
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
    
    @IBAction func playOrPause(_ sender: UIButton) {
        Player.shared.playOrPause()
        playButton.setImage(Player.shared.state.image, for: .normal)
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
        songTitle.text = song.name
        subTitle.text = song.artistName
        thumbnail.kf.setImage(with: song.imageLink, placeholder: UIImage(named: "artistPlayholder"))
    }
    
    func reset() {
        thumbnail.image = UIImage(named: "artistPlaceholder")
        subTitle.text = ""
        songTitle.text = "Not Playing"
        playButton.setImage(PlayerState.notPlaying.image, for: .normal)
    }
    
}

private extension UIView {
    func prepareForAutolayout() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        translatesAutoresizingMaskIntoConstraints = true
    }
}
