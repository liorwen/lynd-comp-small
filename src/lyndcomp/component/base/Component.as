/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.component.base
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import lyndcomp.Lynd;
    import lyndcomp.store.Store;

    public class Component implements IComponent
    {

        private static var _focus:*;

        private var _eventDispatcher:EventDispatcher;
        private var _isAdded:Boolean;
        private var _onAddScreenAtFn:Function;
        protected var _view:*;
        protected var _screen:DisplayObjectContainer;
        protected var _state:ComponentState;
        protected var _lynd:Lynd;

        public function Component(lynd:Lynd, param:Object)
        {
            _lynd = lynd;
            _eventDispatcher = new EventDispatcher();
            _state = new ComponentState();
            if (param.hasOwnProperty("view"))
                _view = param.view;
            if (param.hasOwnProperty("screen"))
                _screen = param.screen;
            if (_view != null && _screen != null)
            {
                if (_view.parent == _screen)
                {
                    _isAdded = true;
                }
            }
            create(param);
        }

        protected function create(param:Object):void
        {

        }

        public function startup():void
        {
            if (!_isAdded)
            {
                addToScreen();
            }
            else
            {
                ready();
            }
        }

        private function addToScreen():void
        {
            if (_isAdded)
                return;
            addEventListener(ComponentEvent.ADD_TO_SCREEN_READY, onAddToScreenReady);
            addToScreenBefore();
        }

        protected function addToScreenBefore():void
        {
            addToScreenReady();
        }

        private function addToScreenReady():void
        {
            dispatchEvent(new ComponentEvent(ComponentEvent.ADD_TO_SCREEN_READY));
        }

        private function onAddToScreenReady(event:ComponentEvent):void
        {
            removeEventListener(ComponentEvent.ADD_TO_SCREEN_READY, onAddToScreenReady);
            _view.addEventListener(Event.ADDED, onAdded);
            _screen.addChild(_view);
        }

        private function onAdded(event:Event):void
        {
            _view.removeEventListener(Event.ADDED, onAdded);
            _isAdded = true;
            ready();
        }

        public function startupAt(index:int):void
        {
            if (!_isAdded)
            {
                addToScreenAt(index);
            }
            else
            {
                ready();
            }
        }

        private function ready():void
        {
            added();
        }

        protected function added():void
        {

        }

        private function addToScreenAt(index:int):void
        {
            _onAddScreenAtFn = getOnAddToScreenAtReady(index);
            addEventListener(ComponentEvent.ADD_TO_SCREEN_READY, _onAddScreenAtFn);
            addToScreenBefore();
        }

        private function getOnAddToScreenAtReady(index:int):Function
        {
            var fn:Function = function (event:ComponentEvent):void
            {
                removeEventListener(ComponentEvent.ADD_TO_SCREEN_READY, _onAddScreenAtFn);
                _onAddScreenAtFn = null;
                _view.addEventListener(Event.ADDED, onAdded);
                _screen.addChildAt(_view, index);
            }
            return fn;
        }

        public function stopup(isRemove:Boolean = false):void
        {
            if (isRemove)
                removeFromScreen();
            removed();
        }

        private function removeFromScreen():void
        {
            if (!_isAdded)
                return;
            _view.addEventListener(Event.REMOVED, onRemoved);
            _screen.removeChild(_view);
        }

        private function onRemoved(event:Event):void
        {
            _view.removeEventListener(Event.REMOVED, onRemoved);
            _isAdded = false;

        }

        protected function removed():void
        {

        }

        public function get state():String
        {
            return _state.state;
        }

        public function set state(value:String):void
        {
            _state.changeState(value);
        }

        final public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            _eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        final public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            _eventDispatcher.removeEventListener(type, listener, useCapture);
        }

        final public function dispatchEvent(event:Event):Boolean
        {
            return _eventDispatcher.dispatchEvent(event);
        }

        final public function hasEventListener(type:String):Boolean
        {
            return _eventDispatcher.hasEventListener(type);
        }

        final public function willTrigger(type:String):Boolean
        {
            return _eventDispatcher.willTrigger(type);
        }

        final protected function checkFocus():Boolean
        {
            if (_focus == null)
                return true;
            if (_focus == this)
                return true;
            return false;
        }

        final protected function changeFocus():void
        {
            _focus = this;
        }

        final protected function clearFocus():void
        {
            if (_focus == this)
                _focus = null;
        }

        public function get isAdded():Boolean
        {
            return _isAdded;
        }

        public function set x(value:Number):void
        {
            _view.x = value;
        }

        public function get x():Number
        {
            return _view.x;
        }

        public function set y(value:Number):void
        {
            _view.y = value;
        }

        public function get y():Number
        {
            return _view.y;
        }

        public function set width(value:Number):void
        {
            _view.width = value;
        }

        public function get width():Number
        {
            return _view.width;
        }

        public function set height(value:Number):void
        {
            _view.height = value;
        }

        public function get height():Number
        {
            return _view.height;
        }

        public function set mouseEnabled(value:Boolean):void
        {
            _view.mouseEnabled = value;
        }

        public function get mouseEnabled():Boolean
        {
            return _view.mouseEnabled;
        }

        public function set visible(value:Boolean):void
        {
            _view.visible = value;
        }

        public function get visible():Boolean
        {
            return _view.visible;
        }

        public function get store():Store
        {
            return _lynd.store;
        }
    }
}
