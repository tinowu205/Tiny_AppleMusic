//
//  BasicPlayController.swift
//  AppleMusic
//
//  Created by tino又想吃肉了 on 2021/6/16.
//

import UIKit
import SnapKit

class BasicPlayController: UIViewController {
    
    public var model : SongModel?
    
    private var albumView : UIImageView?
    
    private var shadowView : UIView?
    
    private var infoView : UIView?
    
    private var controlView : UIView?
    
    private var bottomView : UIView?
    
    private var bgView : UIView?
    
    private var bgImg : UIImage?
    
    private var nameLabel : UILabel?
    
    private var songerLabel : UILabel?
    
    public var processBar : UISlider?
    
    private var btnsArr : Array<UIButton>?
    
    private var volumeBar : UISlider?
    
    public var isPlaying : Bool? {
        didSet{
            changeAlubm(btnsArr![0])
        }
    }
    
    private var bgColor : UIColor?
    
    init(_ img:UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.bgImg = img
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgView = UIView(frame: view.bounds)
        let anoView = UIView(frame: view.bounds)
        anoView.backgroundColor = UIColor(white: 0.7, alpha: 0.3)
        self.bgView?.backgroundColor = .gray
        
        bgImg?.getColors({ [unowned self] (imgColor) in
            bgColor = imgColor?.secondary
            UIView.animate(withDuration: 0.2) {
                [unowned self] in
                self.bgView?.backgroundColor = imgColor?.background
            }
        })
        bgView?.addSubview(anoView)
        view.addSubview(bgView!)
        
        layoutViews()
    }
    
    func layoutViews() {
        
        // album image
        setupAlbumView()
        
        // info view
        setupInfoView()
        
        // control view
        setupControlView()
        
        // bottom View
        setupBottomView()
    }
    
    func setupAlbumView() {
        
        let shadow = UIView()
        shadowView = shadow
        shadow.backgroundColor = bgColor
        shadow.layer.masksToBounds = false
        shadow.layer.shadowOpacity = 0.8
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowRadius = 20
        shadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView?.addSubview(shadow)
        shadow.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(280)
            make.top.equalToSuperview().offset(75)
            make.left.equalToSuperview().offset((bgView?.bounds.width)!/2 - 140)
        }
        
        albumView = UIImageView()
        shadow.addSubview(albumView!)
        albumView?.snp.makeConstraints({ (make) in
            make.center.equalTo(shadow)
            make.size.equalTo(shadow)
        })
        albumView?.image = bgImg
        albumView?.layer.cornerRadius = 10
        //albumView?.clipsToBounds = true
        albumView?.backgroundColor = .white
        albumView?.layer.masksToBounds = true
    }
    
    func setupInfoView() {
        infoView = UIView()
        bgView?.addSubview(infoView!)
        infoView?.snp.makeConstraints({ (make) in
            make.height.equalTo(120)
            make.width.equalTo(ScreenWidth - 40)
            make.top.equalTo(albumView!.snp.centerY).offset(235)
            make.left.equalToSuperview().offset(20)
        })
        infoView?.backgroundColor = .clear
        
        nameLabel = UILabel()
        infoView?.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({ (make) in
            make.height.equalTo(30)
            make.width.equalTo(200)
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(infoView!)
        })
        nameLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel?.text = model?.songName
        nameLabel?.textColor = .lightText
        
        songerLabel = UILabel()
        infoView?.addSubview(songerLabel!)
        songerLabel?.snp.makeConstraints({ (make) in
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.top.equalTo(nameLabel!.snp.bottom).offset(5)
            make.left.equalTo(infoView!)
        })
        songerLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        songerLabel?.textColor = .white
        songerLabel?.text = model?.singerName

        processBar = UISlider()
        infoView?.addSubview(processBar!)
        processBar?.minimumValue = 0
        processBar?.maximumValue = 240
        processBar?.minimumTrackTintColor = .lightGray
        processBar?.maximumTrackTintColor = UIColor(white: 0.5, alpha: 0.3)
        processBar?.value = 60
        processBar?.setThumbImage(UIImage().resizeImage(image: UIImage(systemName: "circle.fill")!, size: CGSize(width: 12, height: 12)), for: .normal)
        
        processBar?.snp.makeConstraints({ (make) in
            make.height.equalTo(50)
            make.width.equalTo(ScreenWidth - 40)
            make.left.equalToSuperview()
            make.top.equalTo(songerLabel!).offset(20)
        })
    }
    
    func setupControlView() {
        controlView = UIView()
        bgView?.addSubview(controlView!)
        controlView?.snp.makeConstraints({ (make) in
            make.height.equalTo(100)
            make.width.equalTo(ScreenWidth - 40)
            make.top.equalTo(infoView!.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
        })
        
        btnsArr = Array<UIButton>()
        
        let centerBtn = UIButton()
        controlView?.addSubview(centerBtn)
        centerBtn.tag = 0
        centerBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
        centerBtn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        centerBtn.tintColor = .white
        centerBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        
        let leftBtn = UIButton(type: .system)
        leftBtn.tag = 1
        controlView?.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(50)
            make.right.equalTo(centerBtn.snp.left).offset(-60)
        }
        leftBtn.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        leftBtn.tintColor = .white
        leftBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        
        let rightBtn = UIButton(type: .system)
        rightBtn.tag = 2
        controlView?.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(50)
            make.left.equalTo(centerBtn.snp.right).offset(60)
        }
        rightBtn.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        rightBtn.tintColor = .white
        rightBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        
        btnsArr = [centerBtn,leftBtn,rightBtn]
    }
    
    @objc func clickBtn(_ btn:UIButton) {
        print("click")
        switch btn.tag {
        case 0:
            if ((isPlaying) != nil && isPlaying!) {
                isPlaying = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "change"), object: false)
            }else{
                isPlaying = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "change"), object: true)
            }
        default:
            print("ssss")
        }
    }
    
    func setupBottomView() {
        bottomView = UIView()
        bgView?.addSubview(bottomView!)
        bottomView?.snp.makeConstraints({ (make) in
            make.height.equalTo(100)
            make.width.equalTo(ScreenWidth - 40)
            make.top.equalTo(controlView!.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
        })
        bottomView?.backgroundColor = .clear
        
        volumeBar = UISlider()
        bottomView?.addSubview(volumeBar!)
        volumeBar?.minimumTrackTintColor = .lightGray
        volumeBar?.maximumTrackTintColor = UIColor(white: 0.5, alpha: 0.3)
        volumeBar?.value = 0.4
        
        volumeBar?.minimumValueImage = UIImage(systemName: "speaker.fill")?.withTintColor(.lightGray)
        volumeBar?.tintColor = .lightGray
        volumeBar?.maximumValueImage = UIImage(systemName: "speaker.3.fill")?.withTintColor(.lightGray)
        
        volumeBar?.snp.makeConstraints({ (make) in
            make.height.equalTo(50)
            make.width.equalTo(ScreenWidth - 80)
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview()
        })
        
        let airdrop = UIButton()
        bottomView?.addSubview(airdrop)
        airdrop.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(30)
        }
        airdrop.setImage(UIImage(systemName: "wifi"), for: .normal)
        airdrop.tintColor = .white
        
        let lyrics = UIButton()
        bottomView?.addSubview(lyrics)
        lyrics.snp.makeConstraints { (make) in
            make.centerY.equalTo(airdrop)
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.right.equalTo(airdrop.snp.left).offset(-80)
        }
        lyrics.setImage(UIImage(systemName: "quote.bubble"), for: .normal)
        lyrics.tintColor = .white
        
        let list = UIButton()
        bottomView?.addSubview(list)
        list.snp.makeConstraints { (make) in
            make.centerY.equalTo(airdrop)
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.left.equalTo(airdrop.snp.right).offset(80)
        }
        list.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        list.tintColor = .white
    }
    
    func changeAlubm(_ btn:UIButton) {
        if isPlaying ?? false{
            btn.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            shadowView?.snp.updateConstraints({ (make) in
                make.size.equalTo(374)
                make.left.equalToSuperview().offset((bgView?.bounds.width)!/2 - 187)
                make.top.equalToSuperview().offset(28)
            })
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { (done) in
            }
            
        }else{
            btn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
            shadowView?.snp.updateConstraints({ (make) in
                make.width.equalTo(280)
                make.height.equalTo(280)
                make.top.equalToSuperview().offset(75)
                make.left.equalToSuperview().offset((bgView?.bounds.width)!/2 - 140)
            })
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { (done) in
            }

        }
    }
}
