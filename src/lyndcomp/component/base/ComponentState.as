/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.component.base
{
    import flash.utils.Dictionary;

    public class ComponentState
    {
        private var _state:String;
        private var _stateDict:Dictionary;

        public function ComponentState()
        {
            _stateDict = new Dictionary();
            _state ="";
        }

        final public function addState(state:String, stateIn:Function, stateOut:Function = null):void
        {
            _stateDict[state] = {stateIn: stateIn, stateOut: stateOut};
        }

        final public function hasState(state:String):Boolean
        {
            if (!_stateDict[state])
                return false;
            return true;
        }

        final public function removeState(state:String):void
        {
            if (_stateDict[state] == null)
                return;
            _stateDict[state] = null
            delete _stateDict[state];
        }

        final public function clearState():void
        {
            if (_state != "")
            {
                if(_stateDict[_state] != null)
                {
                    if(_stateDict[_state].stateOut != null)
                        _stateDict[_state].stateOut.apply();
                }
            }
            for(var key:* in _stateDict)
            {
                _stateDict[key] = null;
                delete _stateDict[key];
            }
        }

        final public function changeState(state:String):void
        {
            if (!_stateDict[state])
                return;
            if (_state != "")
            {
                if(_stateDict[_state] != null)
                {
                    if(_stateDict[_state].stateOut != null)
                        _stateDict[_state].stateOut.apply();
                }
            }
            _state = state;
            _stateDict[_state].stateIn.apply();
        }

        final public function get state():String
        {
            return _state;
        }
    }
}
