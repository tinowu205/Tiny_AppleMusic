//
//  TabBarController.swift
//  AppleMusic
//
//  Created by tino又想吃肉了 on 2021/6/16.
//

import UIKit
import UIImageColors

class TabBarController: UITabBarController,UpdateInfo {
    func updateSong(model: SongModel, duration: TimeInterval) {
        var img = UIImage(named: model.albumImage)
        img = resizeImage(image: img!, size: CGSize(width: 50, height: 50))
        //let imageItem = UIBarButtonItem(customView: UIImageView().clipRadiu(UIImageView(image: img), 5))
        basicPlayView?.items![0].customView = UIImageView().clipRadiu(UIImageView(image: img), 5)
        
        let songName = basicPlayView?.items![2].customView as! UILabel
        songName.text = model.songName
        
        playingModel = model
        
        songTime = duration
        
        clickPlay()
    }
    
    func updateTime(time: TimeInterval) {
        basicPlayVC?.processBar?.value = Float(time)
    }
    
    func updatePlayStatus(bool: Bool) {
        isPlaying = bool
    }
    
    var model : Array<SongModel>?
    
    var basicPlayView : UIToolbar?
    
    var isPlaying = false {
        didSet{
            changePlayStatus()
        }
    }
    
    var homeVC : HomeViewController?
    
    var playingModel : SongModel?
    
    var basicPlayVC : BasicPlayController?
    
    var songTime : TimeInterval?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.tintColor = .red
        //self.tabBar.safeAreaInsets
        
        let vc = HomeViewController(model: model!)
        vc.delegate = self
        homeVC = vc
        
        vc.title = "资料库"
        vc.tabBarItem.image = UIImage(systemName: "square.stack")
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.navigationBar.prefersLargeTitles = true
        
        vc.view.backgroundColor = .white
        
        self.addChild(nav)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var img = UIImage(named: "1")
        img = resizeImage(image: img!, size: CGSize(width: 50, height: 50))
        let imageItem = UIBarButtonItem(customView: UIImageView().clipRadiu(UIImageView(image: img), 5))
        
        let songName = UILabel()
        
        let song = model![0]
        
        songName.text = song.songName
//        songName.text = "不为谁而作的歌"
        songName.font = UIFont.boldSystemFont(ofSize: 18)
        
        let name = UIBarButtonItem(customView: songName)
        
        let playBtn = UIButton()
        playBtn.setImage(UIImage(systemName: "play"), for: .normal)
        playBtn.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
        
        let playOrPause = UIBarButtonItem(customView: playBtn)
        
        let nextItem = UIBarButtonItem(customView: UIImageView(image: UIImage(systemName: "forward")))
        
        basicPlayView = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 150, width: UIScreen.main.bounds.width, height: 70))
        basicPlayView?.backgroundColor = .clear
        basicPlayView?.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(presentPlayView)) )
        let line = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 158 + 78, width: UIScreen.main.bounds.width, height: 0.3))
        line.backgroundColor = UIColor.lightGray
        
        basicPlayView?.setItems([imageItem, UIBarButtonItem.fixedSpace(20),name,UIBarButtonItem.flexibleSpace(),playOrPause,UIBarButtonItem.fixedSpace(20),nextItem], animated: true)
        basicPlayView?.tintColor = .red
        
        
        view.addSubview(basicPlayView!)
        view.addSubview(line)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(clickPlay), name: NSNotification.Name(rawValue: "change"), object: nil)
    }
    
    // MARK: 重构！！nm疯狂if else
    @objc func presentPlayView () {
        if let temp = playingModel { // 模型解包
            if let vc = basicPlayVC { // VC解包
                if vc.model == temp { // model没变
                    self.present(vc, animated: true) {
                        
                    }
                    vc.isPlaying = isPlaying
                }else{
                    let img = UIImage(named: temp.albumImage)
                    let vc = BasicPlayController(img!)
                    vc.model = temp
                    vc.processBar?.maximumValue = Float(songTime ?? 0)
                    basicPlayVC = vc
                    self.present(vc, animated: true) {
                        
                    }
                    vc.isPlaying = isPlaying
                }
            }else{
                let img = UIImage(named: temp.albumImage)
                let vc = BasicPlayController(img!)
                
                vc.model = temp
                vc.processBar?.maximumValue = Float(songTime ?? 0)
                basicPlayVC = vc
                
                self.present(vc, animated: true) {
                    
                }
                vc.isPlaying = isPlaying
            }
        }else{ // 默认
            if let vc = basicPlayVC {
                
                self.present(vc, animated: true) {
                    
                }
                vc.isPlaying = isPlaying
            }else{
                let img = UIImage(named: "1")
                let vc = BasicPlayController(img!)
                
                vc.model = SongModel("不为谁而作的歌", "林俊杰", NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/林俊杰 - 不为谁而作的歌.flac",albumImage: "1")
                vc.processBar?.maximumValue = Float(songTime ?? 240)
                basicPlayVC = vc
                self.present(vc, animated: true) {
                    
                }
                vc.isPlaying = isPlaying
            }
        }
        
    }
    
    @objc func clickPlay () {
        print("play")
        if isPlaying { // 播放中
            //var btn = basicPlayView?.items![4]
            
            isPlaying = false
            
        }else{
            //let btn = basicPlayView?.items![4]
            
            isPlaying = true
            
        }
    }
    
    func changePlayStatus() {
        if isPlaying {
            let playBtn = UIButton()
            playBtn.setImage(UIImage(systemName: "pause"), for: .normal)
            playBtn.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
            basicPlayView?.items![4] = UIBarButtonItem(customView: playBtn)
            homeVC?.player?.prepareToPlay()
            homeVC?.player?.play()
            //homeVC?.delegate?.updatePlayStatus(bool: true)
        }else{
        
            let playBtn = UIButton()
            playBtn.setImage(UIImage(systemName: "play"), for: .normal)
            playBtn.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
            basicPlayView?.items![4] = UIBarButtonItem(customView: playBtn)
            homeVC?.player?.stop()
            //homeVC?.delegate?.updatePlayStatus(bool: false)
        }
    }
    
    func resizeImage(image:UIImage, size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized ?? UIImage()
    }

}
extension UIImage {
    func resizeImage(image:UIImage, size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()?.withTintColor(.white)
        //resized = resized?.withTintColor(.white)
        UIGraphicsEndImageContext()
        
        return resized ?? UIImage()
    }
}
