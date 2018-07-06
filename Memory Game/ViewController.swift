import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var tileWidth: CGFloat!
    
    var tilesArr: NSMutableArray = []
    var centersArr: NSMutableArray = []
    
    var curTime: Int = 0
    var gameTimer: Timer = Timer()
    
    
    // IRIS - DECLARE THE ARRAY
    var imgArr: NSArray = [];
    
    
    var compareState : Bool = false
    
    
    // IRIS - Tiles, are no longer MyLabels. They are now MyImageViews
//    var firstTile : MyLabel!
//    var secondTile : MyLabel!

    
        var firstTile : MyImageView!
        var secondTile : MyImageView!
    
    @IBAction func resetAction(_ sender: Any) {
        
        for anyView in gameView.subviews {
            anyView.removeFromSuperview()
        }
        tilesArr = []
        centersArr = []
        blockMakerAction()
        randomizeAction()
        for anyTile in tilesArr {
            (anyTile as! MyImageView).image = UIImage(named: "empty.jpg");
        }
        
        
        curTime = 0
        gameTimer.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerFunc),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc func timerFunc ()
    {
        curTime += 1
        
        let timeMins: Int = curTime / 60
        let timeSecs: Int = curTime % 60
        
        let timeStr : String = NSString(format: "%02d\' : %02d\"", timeMins, timeSecs) as String
        timerLabel.text = timeStr
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // CALL THE METHOD
        self.putImagesIntoArray();
        
        self.resetAction(Any.self)
    }
    
    // IRIS -- PUT THE IMAGES IN THE ARRAY
    func putImagesIntoArray()
    {
        imgArr = NSArray(objects:
            UIImage(named: "flickr-5636162627.png")!,
                         UIImage(named: "flickr-7461407466.png")!,
                         UIImage(named: "flickr-9380453461.png")!,
                         UIImage(named:  "pixabay-1692849.png")!,
                         UIImage(named:  "pixabay-2119595.png")!,
                         UIImage(named:  "pixabay-3046269.png")!,
                         UIImage(named:  "pixabay-3221498.png")!,
                         UIImage(named:  "pixabay-3460133.png")!);
    }
    
    
    
    func randomizeAction ()
    {
        for tile in tilesArr
        {
            let randIndex: Int = Int ( arc4random() ) % centersArr.count
            
            let randCen: CGPoint = centersArr[randIndex] as! CGPoint
            
            
            // NO MORE A MYLABEL
//            (tile as! MyLabel).center = randCen
            
            (tile as! MyImageView).center = randCen;
            
            centersArr.removeObject(at: randIndex)
        }
        
    }
    
    func blockMakerAction ()
    {
        tileWidth = gameView.frame.size.width / 4
       
        var xCen: CGFloat = tileWidth / 2
        var yCen: CGFloat = tileWidth / 2
        

        let tileFrame: CGRect = CGRect(x: 0,
                                       y: 0,
                                       width: tileWidth - 4,
                                       height: tileWidth - 4 )
        
        var counter: Int = 0    // i changed this to counter starts from zero
                                // because imgArr starts from Zero
        
        for _ in 0..<4
        {
            for _ in 0..<4
            {
                
                
                // IRS - replace below
//                let tile: MyLabel = MyLabel(frame: tileFrame)
                
                // WITH
                let tile: MyImageView = MyImageView(frame: tileFrame)

                
                
                if ( counter > 7)
                {
                    counter = 0
                }
                
                // IRIS - Assign the right image
                tile.image = imgArr[counter] as? UIImage;
                tile.tagNumber = counter

                // remove the next few lines
//                tile.text = String( counter )
//                tile.textAlignment = NSTextAlignment.center
//                tile.font = UIFont.boldSystemFont(ofSize: 30)
                
                
                let cen: CGPoint = CGPoint(x: xCen, y: yCen)
                
                tile.isUserInteractionEnabled = true
                
                tile.center = cen
                tile.backgroundColor = UIColor.darkGray
                gameView.addSubview(tile)
                
                tilesArr.add(tile)
                centersArr.add(cen)
                
                
                xCen = xCen + tileWidth
                counter += 1
            }
            yCen = yCen + tileWidth
            xCen = tileWidth / 2
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouch: UITouch = touches.first!
        
        if (tilesArr.contains(myTouch.view as Any))
        {
            
            // IRIS - touched view is no longer a MyLabel. SO remove next and replace
//            let thisTile : MyLabel = myTouch.view as! MyLabel
            // WITH
            let thisTile : MyImageView = myTouch.view as! MyImageView
            
            
            UIView.transition(with: thisTile,
                              duration: 0.75,
                              options: UIViewAnimationOptions.transitionFlipFromRight,
                              animations: {
                                
                                // it's now a MyImageView. SO
//                                thisTile.text = String ( thisTile.tagNumber )
                                thisTile.image = (self.imgArr[thisTile.tagNumber] as! UIImage);
                                
                                thisTile.backgroundColor = UIColor.purple
            },
                              completion: { (true) in
                                if ( self.compareState)
                                {
                                    // let's compare
                                    self.compareState = false
                                    self.secondTile = thisTile
                                    self.compareAction ()
                                    // now we are ready for comparison
                                }
                                else
                                {
                                 // only flip
                                    self.firstTile = thisTile
                                    self.compareState = true
                                }
            })
        }
    }
    
    
    
    func flipThemBack (anyInp:Array<Any>)   {
        for anyObj in anyInp    {
            
            // U KNOW WHAT TO DO
//            let thisTile = anyObj as! MyLabel
            let thisTile = anyObj as! MyImageView
            
            UIView.transition(with: thisTile,
                              duration: 0.75,
                              options: UIViewAnimationOptions.transitionFlipFromRight,
                              animations: {
                                
                                
//                                thisTile.text = "😀"
                                thisTile.image = UIImage(named:"success.png");
                                
                                thisTile.backgroundColor = UIColor.green
            }, completion: nil)
        }
    }
    
    func compareAction() {
        
  
        if ( firstTile.tagNumber == secondTile.tagNumber)   {
            

            
            
            self.flipThemBack(anyInp: [firstTile, secondTile])
        }
        else   {

            UIView.transition(with: self.view,
                              duration: 0.75,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {
                                
                                self.firstTile.image = UIImage(named: "empty.jpg")
                                self.secondTile.image = UIImage(named: "empty.jpg")
                                
//                                self.firstTile.text = "?"
//                                self.secondTile.text = "?"
                                self.firstTile.backgroundColor = UIColor.darkGray
                                self.secondTile.backgroundColor = UIColor.darkGray
            }, completion: nil)
        }
        
    }
}









class My_Label: UILabel {
    var tagNumber: Int!
}



// IRIS STEP 1
class MyImageView: UIImageView
{
    var tagNumber: Int!
}





