/**
 * Created by zear19st on 2016/12/16.
 */
package lyndcomp.services.loader
{
    public interface ILoaderFactory
    {
        function load(type:String, path:String, config:Object, container:*, callback:Function):void
    }
}
