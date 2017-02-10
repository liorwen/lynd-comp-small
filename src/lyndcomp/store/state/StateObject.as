/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.store.state
{
    import flash.utils.flash_proxy;
    import flash.utils.getQualifiedClassName;

    import lyndcomp.tool.util;

    use namespace flash_proxy;

    dynamic public class StateObject extends StoreState
    {
        public function StateObject(path:String)
        {
            super(path);
            _property = {};
        }

        protected function getChild():Object
        {
            return _property as Object;
        }

        override flash_proxy function getProperty(name:*):*
        {
            if (!getChild().hasOwnProperty(name))
            {
                var valuePath:String = getValuePath(name);
                getChild()[name] = getState(valuePath, value);
            }
            return getChild()[name];
        }

        override flash_proxy function setProperty(name:*, value:*):void
        {
            var valuePath:String = getValuePath(name);
            if (!getChild().hasOwnProperty(name))
                getChild()[name] = getState(valuePath, value);
            else if (!util.compareClass(getChild()[name], getStateClass(value)))
            {
                delete getChild()[name];
                getChild()[name] = getState(valuePath, value);
            }
            else
                getChild()[name].value = value;
        }

        override flash_proxy function deleteProperty(name:*):Boolean
        {
            if (getChild().hasOwnProperty(name))
            {
                getChild()[name].destroy();
                getChild()[name].removeEventListener(StateEvent.PROPERTY_CHANGE, onChildListen);
                getChild()[name].removeEventListener(StateEvent.PROPERTY_DELETE, onChildListen);
                delete getChild()[name];
            }
            return true;
        }

        override public function get value():*
        {
            var res:Object = {};
            for (var key:* in getChild())
            {
                res[key] = getChild()[key].value;
            }
            return res;
        }

        override public function set value(value:*):void
        {
            var oldValue:* = this.value;
            for (var key:* in value)
            {
                setProperty(key, value[key]);
            }
            dispatchEvent(new StateEvent(StateEvent.PROPERTY_CHANGE, path, getQualifiedClassName(value), oldValue, value));
        }

        override public function destroy():void
        {
            var delValue:Object = value;
            var valuePath:String;
            for (var key:* in getChild())
            {
                valuePath = getValuePath(key);
                getChild()[key].destroy();
                getChild()[key].removeEventListener(StateEvent.PROPERTY_CHANGE, onChildListen);
                getChild()[key].removeEventListener(StateEvent.PROPERTY_DELETE, onChildListen);
                delete getChild()[key];
            }
            dispatchEvent(new StateEvent(StateEvent.PROPERTY_DELETE, path, getQualifiedClassName(delValue), null, delValue));
        }
    }
}
