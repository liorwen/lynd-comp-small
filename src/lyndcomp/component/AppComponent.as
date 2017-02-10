/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.component
{
    import flash.display.Sprite;

    import lyndcomp.Lynd;
    import lyndcomp.component.base.Component;

    public class AppComponent extends Component
    {
        public function AppComponent(lynd:Lynd)
        {
            super(lynd,  {view: new Sprite(), screen: lynd.root});
        }
    }
}
