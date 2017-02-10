/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.store.state
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    import flash.utils.getQualifiedClassName;

    use namespace flash_proxy;

    dynamic public class StoreState extends Proxy implements IState
    {
        private var _eventDispatcher:EventDispatcher;
        private var _path:String;
        private var _stateDict:Dictionary;
        protected var _property:Object;
        private var _propertyIndex:Array;

        public function StoreState(path:String)
        {
            super();
            _path = path;
            _eventDispatcher = new EventDispatcher();
            _stateDict = new Dictionary();
            _propertyIndex = [];
            _stateDict[getQualifiedClassName(Object)] = StateObject;
            _stateDict[getQualifiedClassName(Array)] = StateArray;
            _stateDict[getQualifiedClassName(StateNode)] = StateNode;
        }

        protected function getState(path:String, value:*):StoreState
        {
            var className:String = getQualifiedClassName(value);
            var res:StoreState;
            if (_stateDict[className] == null)
                res = new _stateDict[getQualifiedClassName(StateNode)](path);
            else
                res = new _stateDict[className](path);
            res.addEventListener(StateEvent.PROPERTY_CHANGE, onChildListen);
            res.addEventListener(StateEvent.PROPERTY_DELETE, onChildListen);
            res.value = value;
            return res;
        }

        protected function onChildListen(event:StateEvent):void
        {
            dispatchEvent(event.clone());
        }

        protected function getStateClass(value:*):Class
        {
            var className:String = getQualifiedClassName(value);
            if (_stateDict[className] == null)
                return _stateDict[getQualifiedClassName(StateNode)];
            return _stateDict[className];
        }

        protected function getValuePath(name:*):String
        {
            return [path, name].join(".");
        }

        override flash_proxy function callProperty(name:*, ...rest):*
        {
            return _property[name].apply(null, rest);
        }

        override flash_proxy function hasProperty(name:*):Boolean
        {
            return _property.hasOwnProperty(name);
        }

        override flash_proxy function nextNameIndex(index:int):int
        {
            if (index == 0)
            {
                _propertyIndex.length = 0;
                for (var name:* in _property)
                {
                    _propertyIndex.push(name);
                }
            }
            if (index < _propertyIndex.length)
                return index + 1;
            return 0;
        }

        override flash_proxy function nextName(index:int):String
        {
            return _propertyIndex[index - 1];
        }

        override flash_proxy function nextValue(index:int):*
        {
            return _property[_propertyIndex[index - 1]];
        }

        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            _eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            _eventDispatcher.removeEventListener(type, listener, useCapture);
        }

        public function dispatchEvent(event:Event):Boolean
        {
            return _eventDispatcher.dispatchEvent(event);
        }

        public function hasEventListener(type:String):Boolean
        {
            return _eventDispatcher.hasEventListener(type);
        }

        public function willTrigger(type:String):Boolean
        {
            return _eventDispatcher.willTrigger(type);
        }

        final public function get path():String
        {
            return _path;
        }

        public function get value():*
        {
            return null;
        }

        public function set value(value:*):void
        {
            var oldValue:* = this.value;
            for (var key:* in value)
            {
                setProperty(key, value[key]);
            }
            dispatchEvent(new StateEvent(StateEvent.PROPERTY_CHANGE, path, getQualifiedClassName(value), oldValue, value));
        }

        public function destroy():void
        {
        }
    }
}
