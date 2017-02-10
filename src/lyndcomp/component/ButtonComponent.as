/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.component
{
    import flash.events.MouseEvent;
    import flash.geom.Point;

    import lyndcomp.Lynd;
    import lyndcomp.component.base.*;
    import lyndcomp.tool.util;

    public class ButtonComponent extends Component
    {
        static public const NORMAL:String = "ButtonComponent.Normal";
        static public const DOWN:String = "ButtonComponent.Down";

        public function ButtonComponent(lynd:Lynd, param:Object)
        {
            super(lynd, param);
        }

        override protected function create(param:Object):void
        {
            _view.buttonMode = true;
        }

        override protected function added():void
        {
            _state.addState(NORMAL, inNormalState, outNormalState);
            _state.addState(DOWN, inDownState, outDownState);
            _view.addEventListener(MouseEvent.CLICK, onClick);
            state = NORMAL;
        }

        override protected function removed():void
        {
            _state.clearState();
            _view.removeEventListener(MouseEvent.CLICK, onClick);
        }

        private function inNormalState():void
        {
            _view.gotoAndStop(1);
            _view.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            _view.addEventListener(MouseEvent.MOUSE_OVER, onNormalOver);
            _view.addEventListener(MouseEvent.MOUSE_OUT, onNormalOut);
        }

        private function outNormalState():void
        {
            _view.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
            _view.removeEventListener(MouseEvent.MOUSE_OVER, onNormalOver);
            _view.removeEventListener(MouseEvent.MOUSE_OUT, onNormalOut);
        }

        private function onNormalOut(event:MouseEvent):void
        {
            if (!checkFocus())
                return;
            _view.gotoAndStop(1);
        }

        private function onNormalOver(event:MouseEvent):void
        {
            if (!checkFocus())
                return;
            _view.gotoAndStop(2);
        }

        private function onDown(event:MouseEvent):void
        {
            if (!checkFocus())
                return;
            state = DOWN;
            dispatchEvent(event.clone());
        }


        private function inDownState():void
        {
            changeFocus();
            _view.gotoAndStop(3);
            _lynd.root.addEventListener(MouseEvent.MOUSE_UP, onUp);
            _view.addEventListener(MouseEvent.MOUSE_OVER, onDownOver);
            _view.addEventListener(MouseEvent.MOUSE_OUT, onDownOut);
        }

        private function outDownState():void
        {
            _lynd.root.removeEventListener(MouseEvent.MOUSE_UP, onUp);
            _view.removeEventListener(MouseEvent.MOUSE_OVER, onDownOver);
            _view.removeEventListener(MouseEvent.MOUSE_OUT, onDownOut);
        }

        private function onUp(event:MouseEvent):void
        {
            clearFocus();
            state = NORMAL;
            var pt:Point = util.getMouseLocalPosition(_lynd.root, _screen);
            var isOver:Boolean = _view.hitTestPoint(pt.x, pt.y, true);
            if (isOver)
                _view.gotoAndStop(2);
            dispatchEvent(event.clone());
        }

        private function onDownOver(event:MouseEvent):void
        {
            _view.gotoAndStop(3);
        }

        private function onDownOut(event:MouseEvent):void
        {
            _view.gotoAndStop(2);
        }

        private function onClick(event:MouseEvent):void
        {
            dispatchEvent(event.clone());
        }


    }
}
