### MVC
## MVC 여기개가 묶여서 한 앱이 되고 NavigationBar로 서브 메뉴를 클락하여 다른 MVC로 가면 현재 rootView 위에 새로운 View가 쌓이는 형태
1. 화면의 전환
+ 하나의 MVC에서 다른 MVC가 나타나게 하는 것을 segue라고 한다
+ NavagationController는 쌓아놓은 카드 형태
+ segues의 종류
    * Show Segue: 다른 MVP 혹은 MVC를 보여줌 카드 형태로 스택 위에 쌓임
    * Show Detail Segue: 디테일한 내용을 보여주는 화면 네이베게이션 컨트롤러에서 쇼와 디테일쇼 동일(네이게이션 컨트롤러가 스플릿뷰안에 있다면 쇼는 컨트롤러 안에 있는 것을 보여달라, 쇼디테일은 스플릿뷰 컨트롤러 것을 보여달라라는 뜻)
    * Modal Segue: 다른 MVC로 전체 화면을 뒤덮어 버리는 연결
    * Popover Segue: 아래에서 올라오는 팝업 형태
+ Segues는 항상 가상으로 새 MVC를 만든다
    * Segue는 새 MVC를 만든다고 생각하면 된다.
    * 컨트롤 + 드래그로 연결하면 된다(인 스토리보드)
    * 스토리보드내에서 연결되는 선의 중간의 원이 세그웨이 이고 Identifier를 가지고 있고 이름 설정해 주어야 함(중요)
    * func performSegueWithIdentifier(identifier: String, sender: AnyObject?)
    * func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "Show Graph":
                    if let vc = segue.destinationViewController as? GraphController {
                        vc.property1 = ...
                        vc.callMethodToSetItUp(...)
                    }
                default: break
            }
        }
    }
    * func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool 
        - 해당 뷰를 그릴 수 없을 때 false 반환 


2. FaceIt MVC에 새 MVC 추가해서 연결
+ StoryBoard에서 새로운 VieController drag & down
+ 새로운 ViewController 생성 EmotionViewController
+ StoryBoard에서 ViewController class 와 연결 className
+ TabBarController 생성 후 2개의 화면 EmotionViewController 와 FaceViewController 연결 (인터페이스라는 것을 명심하라)
+ TabBar는 각각 연결되어 있지 않는 독립성이 강한 MVC로 구성해야 한다.
+ 결국 TabBarController는 이번 프로젝트에 맞지 않아서 삭제
+ TabBarController 삭제시 시작 화면 보여주는 화살표도 같이 삭제 -> 다른 ControllerView inspector에서 is Initial View Controller 체크 하면 생김