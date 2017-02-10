/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.store
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    import lyndcomp.store.state.StateEvent;
    import lyndcomp.store.state.StateObject;

    import lyndcomp.store.state.StoreState;
    import lyndcomp.tool.util;

    public class Store
    {
        private var _state:StoreState;
        private var _mutation:Dictionary;
        private var _listenDict:Dictionary;
        private var _eventDispatcher:EventDispatcher;

        public function Store(param:Object)
        {
            _state = new StateObject("state");
            _mutation = new Dictionary();
            _listenDict = new Dictionary();
            _eventDispatcher = new EventDispatcher();
            _state.addEventListener(StateEvent.PROPERTY_CHANGE, onStateChange);
            _state.addEventListener(StateEvent.PROPERTY_DELETE, onStateDelete);
            register(param);
        }

        private function onStateDelete(event:StateEvent):void
        {

        }

        private function onStateChange(event:StateEvent):void
        {
            _eventDispatcher.dispatchEvent(new StoreEvent(event.path, event.value));
        }

        private function register(param:Object):void
        {
            var module:StoreModule;
            for (var key:* in param)
            {
                if(util.hasExtendsClass(param[key], StoreModule))
                {
                    module = new param[key]();
                    registerState(key, module);
                    registerMutation(key, module);
                }
            }
        }

        private function registerState(key:*, module:Object):void
        {
            state[key].value = module.state;
        }

        private function registerMutation(key:*, module:Object):void
        {
            for (var type:* in module.mutation)
            {
                _mutation[type] = {key: key, fn: module.mutation[type]};
            }
        }

        public function get state():StoreState
        {
            return _state;
        }

        public function commit(type:String, ...res):void
        {
            if (!_mutation[type])
                return;
            res.unshift(state[_mutation[type].key]);
            _mutation[type].fn.apply(null, res);
        }

        public function addListen(state:StoreState, callback:Function):void
        {
            if (state == null)
                return;
            if (hasListen(state, callback))
                return;
            if (_listenDict[state.path] == null)
                _listenDict[state.path] = new Dictionary();
            _listenDict[state.path][callback] = onListen(callback);
            _eventDispatcher.addEventListener(state.path, _listenDict[state.path][callback]);
        }

        private function onListen(callback:Function):Function
        {
            var fn:Function = function (e:StoreEvent):void
            {
                callback.apply(null, [e.value]);
            }
            return fn;
        }

        public function removeListen(state:StoreState, callback:Function):void
        {
            if (!hasListen(state, callback))
                return;
            _eventDispatcher.removeEventListener(state.path, _listenDict[state.path][callback]);
            delete _listenDict[state.path][callback];
        }

        public function hasListen(state:StoreState, callback:Function):Boolean
        {
            if (!_listenDict[state.path])
                return false;
            if (!_listenDict[state.path][callback])
                return false;
            return true;
        }

        public function trigger(state:StoreState):void
        {
            _eventDispatcher.dispatchEvent(new StoreEvent(state.path, state.value));
        }
    }
}
