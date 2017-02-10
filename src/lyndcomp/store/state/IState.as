/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.store.state
{
    import flash.events.IEventDispatcher;

    public interface IState extends IEventDispatcher
    {
        function get path():String;

        function get value():*;

        function set value(value:*):void;

        function destroy():void;
    }
}
