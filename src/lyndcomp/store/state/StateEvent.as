/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.store.state
{
    import flash.events.Event;

    public class StateEvent extends Event
    {
        public static const PROPERTY_CHANGE:String = "StateEvent.PropertyChange";
        public static const PROPERTY_DELETE:String = "StateEvent.PropertyDelete";

        private var _path:String;
        private var _className:String;
        private var _oldValue:*;
        private var _value:*;

        public function StateEvent(type:String, path:String, className:String, oldValue:*, value:*)
        {
            super(type, bubbles, cancelable);
            _path = path;
            _className = className;
            _oldValue = oldValue;
            _value = value;
        }

        override public function clone():Event
        {
            return new StateEvent(type, path, className, oldValue, value);
        }

        public function get path():String
        {
            return _path;
        }

        public function get oldValue():*
        {
            return _oldValue;
        }

        public function get value():*
        {
            return _value;
        }

        public function get className():String
        {
            return _className;
        }
    }
}
