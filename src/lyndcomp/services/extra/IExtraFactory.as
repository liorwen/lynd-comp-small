/**
 * Created by zear19st on 2016/12/16.
 */
package lyndcomp.services.extra
{
    import lyndcomp.services.extra.modules.IExtraModule;

    public interface IExtraFactory
    {
        function getExtra(type:String):IExtraModule;
    }
}
