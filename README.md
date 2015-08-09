# CKWaveCollectionViewTransition

This is a cool custom transition between two or more UICollectionViewControllers with wave like cell animation.
Could be used in e.g. galleries.

![anim.gif](https://raw.githubusercontent.com/CezaryKopacz/CKWaveCollectionViewTransition/master/anim.gif)

Animation idea was taken from [Łukasz Frankiewicz](http://twitter.com/almetien) [Dribble project](https://dribbble.com/shots/2044312-Bits-and-pixels-Tide-Transition)

## Installation

There are two options:

* Via CocoaPods.
* Manually add the files into your Xcode project. Slightly simpler, but updates are also manual.

## Usage

* In storyboard add object in your NavigationController.

![object.jpg](https://raw.githubusercontent.com/CezaryKopacz/CKWaveCollectionViewTransition/master/usage1.jpg)

* Set it's class to NavigationControllerDelegate

![objectCustomClass.jpg](https://raw.githubusercontent.com/CezaryKopacz/CKWaveCollectionViewTransition/master/usage2.jpg)

* Set NavigationController delegate to this object.

![navigationControllerDelegateObject.jpg](https://raw.githubusercontent.com/CezaryKopacz/CKWaveCollectionViewTransition/master/usage3.jpg)

or 

Implement UINavigationControllerDelegate in your ViewController:


```swift
func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            let animator = CKWaveCollectionViewAnimator()
            
            if operation != UINavigationControllerOperation.Push {
                
                animator.reversed = true
            }
            
            return animator
    }
```





## Properties


```swift
internal let animationDuration: Double! = 1.0
```

Total animation duration
   
```swift
internal let kCellAnimSmallDelta: Double! = 0.01
```
 
Small delay between cell animations


```swift
internal let kCellAnimBigDelta: Double! = 0.03
```

Big delay between cell animations

## Requirements

* iOS 7.0+

## License

Released under the MIT license. See the LICENSE file for more info.
