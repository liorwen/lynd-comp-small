/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.component.base
{
    import flash.events.IEventDispatcher;

    import lyndcomp.store.Store;

    public interface IComponent extends IEventDispatcher
    {
        function startup():void;

        function startupAt(index:int):void;

        function stopup(isRemove:Boolean = false):void;

        function get state():String;

        function set state(value:String):void;

        function get isAdded():Boolean;

        function set x(value:Number):void;

        function get x():Number;

        function set y(value:Number):void;

        function get y():Number;

        function set width(value:Number):void;

        function get width():Number;

        function set height(value:Number):void;

        function get height():Number;

        function set mouseEnabled(value:Boolean):void;

        function get mouseEnabled():Boolean;

        function set visible(value:Boolean):void;

        function get visible():Boolean;

        function get store():Store;
    }
}
