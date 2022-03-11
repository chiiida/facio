//
//  VideoPreviewViewController.swift
//  Facio
//
//  Created by Chananchida Fuachai on 5/3/2565 BE.
//

import UIKit
import SnapKit
import AVKit

final class VideoPreviewViewController: UIViewController {
    
    private let videoView = UIView()
    private let saveButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    private var videoPath: URL
    private var arRecoder: ARCapture?
    private var videoSize: CGSize?
    
    private var videoPlayer: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerController = AVPlayerViewController()
    
    init(videoPath: URL, arRecoder: ARCapture?) {
        self.videoPath = videoPath
        self.arRecoder = arRecoder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpViews()
        setUpVideoPlayer()
        setUpNavigationBar()
    }
    
    func setVideoSize(_ size: CGSize) {
        videoSize = size
    }
}

// MARK: - Private functions

extension VideoPreviewViewController {
    
    private func setUpLayout() {
        view.addSubViews(
            videoView,
            saveButton,
            shareButton,
            cancelButton
        )
        
        guard let videoSize = videoSize else { return }
        let scale = 1 / (videoSize.width / videoSize.height)
        
        videoView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(50.0.topSafeAreaAdjusted)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(videoView.snp.width).multipliedBy(scale)
        }
    }
    
    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        cancelButton.titleLabel?.font = .regular(ofSize: .small)
        cancelButton.tintColor = .primaryGray
        
        saveButton.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        saveButton.tintColor = .primaryGray
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        saveButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 5.0)
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .primaryGray
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        shareButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0)
        
        videoView.layer.cornerRadius = 20.0
        videoView.backgroundColor = .red
    }
    
    private func setUpVideoPlayer() {
        playerItem = AVPlayerItem(url: URL(fileURLWithPath: videoPath.path))
        videoPlayer = AVPlayer(playerItem: playerItem)
        videoPlayer?.actionAtItemEnd = .none
        
        playerController.player = videoPlayer
        self.addChild(playerController)
        videoView.addSubview(playerController.view)

        playerController.view.snp.makeConstraints {
            $0.height.width.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: videoPlayer?.currentItem
        )
    
        videoPlayer?.play()
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            videoPlayer?.play()
        }
    }
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: cancelButton)
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: shareButton),
            UIBarButtonItem(customView: saveButton)
        ]
    }
    
    @objc private func didTapCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didTapSaveButton() {
        arRecoder?.addVideoToLibrary(from: videoPath) {[weak self] isSaved in
            DispatchQueue.main.async {
                if isSaved {
                    self?.showSavedIndicator()
                }
            }
        }
    }
    
    @objc private func didTapShareButton() {
        let shareText = "Checkout my video from Facio App!"
        let actionVC = UIActivityViewController(activityItems: [shareText, videoPath], applicationActivities: [])
        present(actionVC, animated: true, completion: nil)
    }
    
    private func showSavedIndicator() {
        let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertView.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .black.withAlphaComponent(0.5)
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.alignment = .center

        let checkImageView = UIImageView()
        checkImageView.image = UIImage(systemName: "checkmark.circle")
        checkImageView.tintColor = .white
        
        let messageLabel = UILabel()
        messageLabel.text = "Saved"
        messageLabel.font = .regular(ofSize: .medium)
        messageLabel.textColor = .white
        
        stackView.addArrangedSubViews(
            checkImageView,
            messageLabel
        )
        alertView.view.addSubViews(
            stackView
        )
        checkImageView.snp.makeConstraints {
            $0.height.width.equalTo(60.0)
        }
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        alertView.view.snp.makeConstraints {
            $0.height.width.equalTo(150.0)
        }
        
        present(alertView, animated: true, completion: nil)
        UIView.animate(withDuration: 1.5) {
            alertView.dismiss(animated: true, completion: nil)
        }
    }
}
