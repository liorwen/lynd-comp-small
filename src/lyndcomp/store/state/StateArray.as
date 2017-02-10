/**
 * Created by zear19st on 2017/1/18.
 */
package lyndcomp.store.state
{
    import flash.utils.flash_proxy;
    import flash.utils.getQualifiedClassName;

    import lyndcomp.tool.util;

    use namespace flash_proxy;

    public class StateArray extends StoreState
    {
        public function StateArray(path:String)
        {
            super(path);
            _property = new Vector.<StoreState>();
        }

        private function getChild():Vector.<StoreState>
        {
            return _property as Vector.<StoreState>;
        }

        override flash_proxy function getProperty(name:*):*
        {
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
            return false;

        }

        override flash_proxy function getDescendants(name:*):*
        {
            return super.flash_proxy::getDescendants(name);
        }

        override flash_proxy function isAttribute(name:*):Boolean
        {
            return super.flash_proxy::isAttribute(name);
        }

        override public function get value():*
        {
            var res:Array = [];
            for (var key:* in getChild())
            {
                if (getChild()[key] != null)
                    res.push(getChild()[key].value);
                else
                    res.push(null);
            }
            return res;
        }

        override public function set value(value:*):void
        {
            var oldValue:* = this.value;
            var i:*;
            for (i in getChild())
            {
                deleteProperty(i);
            }
            for (i in value)
            {
                setProperty(i, value[i]);
            }
            dispatchEvent(new StateEvent(StateEvent.PROPERTY_CHANGE, path, getQualifiedClassName(value), oldValue, value));
        }


        override protected function getValuePath(name:*):String
        {
            return [path, name].join(".");
        }

        public function push(...rest):uint
        {
            var len:uint = getChild().length;
            for (var i:* in rest)
            {
                setProperty(len + i, rest[i]);
            }
            return getChild().length;
        }

        public function unshift(...rest):uint
        {
            var nodes:Array = this.value;
            nodes.unshift.apply(null, rest);
            for (var i:* in nodes)
            {
                setProperty(i, nodes[i]);
            }
            return getChild().length;
        }

        public function pop():*
        {
            var node:StoreState;
            node = getChild().pop();
            node.destroy();
            node.removeEventListener(StateEvent.PROPERTY_CHANGE, onChildListen);
            node.removeEventListener(StateEvent.PROPERTY_DELETE, onChildListen);
            return node.value;
        }

        public function shift():*
        {
            var node:StoreState;
            node = getChild().shift();
            node.destroy();
            node.removeEventListener(StateEvent.PROPERTY_CHANGE, onChildListen);
            node.removeEventListener(StateEvent.PROPERTY_DELETE, onChildListen);
            return node.value;
        }

        public function removeAt(index:int):*
        {
            var len:int = getChild().length;
            if (index >= len)
                return null;
            if (index < 0)
                index = len - 1;
            var node:StoreState;
            node = getChild().splice(index, 1)[0];
            node.destroy();
            node.removeEventListener(StateEvent.PROPERTY_CHANGE, onChildListen);
            node.removeEventListener(StateEvent.PROPERTY_DELETE, onChildListen);
            var res:* = node.value;
//            dispatchEvent(new StateEvent(StateEvent.PROPERTY_DELETE, getValuePath(index), null, null));
            return res;
        }

        public function set length(value:uint):void
        {
            var i:*;
            if (value < length)
            {
                var nodes:Vector.<StoreState> = getChild().splice(value, length - value);
                for (i in nodes)
                {
                    nodes[i].destroy();
                    nodes[i].removeEventListener(StateEvent.PROPERTY_CHANGE, onChildListen);
                    nodes[i].removeEventListener(StateEvent.PROPERTY_DELETE, onChildListen);
//                    dispatchEvent(new StateEvent(StateEvent.PROPERTY_DELETE, getValuePath(value + i), null, null));
                }
            }
            else if (value > length)
            {
                var start:int = length;
                for (i = start; i < value; i++)
                {
                    setProperty(i, null);
                }
            }
            getChild().length = value;
        }

        public function get length():uint
        {
            return getChild().length;
        }

        override public function destroy():void
        {

            var delValue:Object = value;
            var nodes:Vector.<StoreState> = getChild().splice(0, getChild().length);
            for (var i:* in nodes)
            {
                nodes[i].destroy();
                nodes[i].removeEventListener(StateEvent.PROPERTY_CHANGE, onChildListen);
                nodes[i].removeEventListener(StateEvent.PROPERTY_DELETE, onChildListen);
            }
            dispatchEvent(new StateEvent(StateEvent.PROPERTY_DELETE, path, getQualifiedClassName(delValue), null, delValue));
        }
    }
}
