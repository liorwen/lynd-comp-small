/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.store.state
{
    import flash.utils.flash_proxy;
    import flash.utils.getQualifiedClassName;

    use namespace flash_proxy;

    public class StateNode extends StoreState
    {
        public function StateNode(path:String)
        {
            super(path);
        }

        override flash_proxy function deleteProperty(name:*):Boolean
        {
            return false;
        }

        override public function get value():*
        {
            return _property;
        }

        override public function set value(value:*):void
        {
            var oldValue:* = _property;
            _property = value;
            dispatchEvent(new StateEvent(StateEvent.PROPERTY_CHANGE, path, getQualifiedClassName(value), oldValue, value));
        }

        override public function destroy():void
        {
            dispatchEvent(new StateEvent(StateEvent.PROPERTY_DELETE, path, getQualifiedClassName(_property), null, _property));
            _property = null;
        }
    }
}
