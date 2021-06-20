//
//  HomeViewController.swift
//  AppleMusic
//
//  Created by tino又想吃肉了 on 2021/6/16.
//

import UIKit
import AVFoundation

let ScreenHeight = UIScreen.main.bounds.height
let ScreenWidth = UIScreen.main.bounds.width

protocol Play {
    func playSong()
}

protocol UpdateInfo : NSObject {
    func updateSong(model : SongModel , duration : TimeInterval)
    func updateTime(time : TimeInterval)
    func updatePlayStatus(bool : Bool)
}

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,AVAudioPlayerDelegate {
    
    weak var delegate : UpdateInfo?
    
    private var bgView : UIScrollView?
    
    private var tableView : UITableView?
    
    private var imagesView : UICollectionView?
    
    public var player : AVAudioPlayer?
    
    private var model : Array<SongModel> = []
    
    private let listTextContent = ["播放列表","艺人","专辑","歌曲","已下载"]
    private let listImageContent = ["music.note.list","music.mic","rectangle.stack","music.note","square.and.arrow.down"]
    
    init(model : Array<SongModel>) {
        super.init(nibName: nil, bundle: nil)
        
        self.model = model
        
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getTime), userInfo: nil, repeats: true)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func getTime() {
        //print(player?.currentTime)
        self.delegate?.updateTime(time: player?.currentTime ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutViews()
    }
    
    func layoutViews() {
        // MARK: tableview
        bgView = UIScrollView(frame: UIScreen.main.bounds)
        bgView?.contentSize = CGSize(width: ScreenWidth, height: 5 * ScreenHeight)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 10, width: ScreenWidth - 20, height: 240), style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        
        bgView!.addSubview(tableView!)
        
        view.addSubview(bgView!)
        
        // MARK: collectionview
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize(width: ScreenWidth / 2 - 25, height: ScreenWidth / 2 - 25)
        
        imagesView = UICollectionView(frame: CGRect(x: 20, y: (tableView?.frame.maxY ?? 0) + 20, width: ScreenWidth - 40, height: 5 * ScreenHeight), collectionViewLayout: flowLayout)
        //imagesView?.frame = CGRect(x: 10, y: tableView?.frame.maxY ?? 0 + 10, width: ScreenWidth - 20, height: 5 * ScreenHeight)
        imagesView?.delegate = self
        imagesView?.dataSource = self
        imagesView?.backgroundColor = .white
        imagesView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        bgView!.addSubview(imagesView!)
    }
    // MARK: tableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let index = indexPath.row
        
        cell.imageView?.image = UIImage(systemName: listImageContent[index])
        cell.textLabel?.text = listTextContent[index]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.imageView?.tintColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: collectionview delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
//        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let temp = model[indexPath.row]
        let data = UIImage(named: temp.albumImage)?.pngData()
        let imgView = UIImageView(image: UIImage(data: data!))
        
        cell.backgroundView = imgView.clipRadiu(imgView, 30)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let song = model[indexPath.row]

        self.player = try? AVAudioPlayer.init(contentsOf: URL(fileURLWithPath: song.path))
        
        self.delegate?.updateSong(model: song, duration: player?.duration ?? 1)
        self.delegate?.updatePlayStatus(bool: true)
        
        self.player?.delegate = self
        self.player?.prepareToPlay()
        self.player?.play()
        
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        
    }
}

extension UIImageView{
    func clipRadiu(_ imgView : UIImageView,_ radius:CGFloat) -> UIImageView{
        
        // 开启绘图上下文
        UIGraphicsBeginImageContextWithOptions(imgView.bounds.size, false, 0);
        
        // 绘制曲线
        let path = UIBezierPath(roundedRect: imgView.bounds, cornerRadius: radius)
        
        // 添加路径
        path.addClip()
        imgView.draw(imgView.bounds)
        
        // 获取上下文中的image
        imgView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return imgView
    }
    
}
