/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.store
{
    import flash.events.Event;

    public class StoreEvent extends Event
    {
        private var _value:*;

        public function StoreEvent(type:String, value:*)
        {
            super(type, false, false);
            _value = value;
        }

        override public function clone():Event
        {
            return new StoreEvent(type, value);
        }

        public function get value():*
        {
            return _value;
        }
    }
}
