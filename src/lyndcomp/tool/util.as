/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp.tool
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    public class util
    {
        public function util()
        {
        }

        public static function hasInterface(value:*, checkInterface:*):Boolean
        {
            var checkInterfaceLink:String = getQualifiedClassName(checkInterface);
            var calssXml:XML = describeType(value);
            var interfaceLength:int = calssXml.factory.implementsInterface.(@type == checkInterfaceLink).length();
            if (interfaceLength > 0)
                return true;
            return false;
        }

        public static function hasExtendsClass(value:*, checkClass:*):Boolean
        {
            var checkClassLink:String = getQualifiedClassName(checkClass);
            var calssXml:XML = describeType(value);
            var extendsClassLength:int = calssXml.factory.extendsClass.(@type == checkClassLink).length();
            if (extendsClassLength > 0)
                return true;
            return false;
        }

        public static function compareClass(target:*, contrast:*):Boolean
        {
            if (getQualifiedClassName(target) == getQualifiedClassName(contrast))
                return true;
            return false;
        }

        static public function copyBitmap(target:Bitmap):Bitmap
        {
            var cloneBitmapData:BitmapData = new BitmapData(target.width, target.height);
            var rect:Rectangle = new Rectangle(0, 0, target.width, target.height);
            var point:Point = new Point(0, 0);
            cloneBitmapData.copyPixels(target.bitmapData, rect, point);
            var cloneBitmap:Bitmap = new Bitmap(cloneBitmapData);

            return cloneBitmap;
        }

        static public function compConfig(infoClass:Class):Object
        {
            var xml:XML = describeType(infoClass);
            var constant:XMLList = xml.constant;
            var result:Object = {};
            result["file"] = "";
            result["components"] = {};
            for each(var node:XML in constant)
            {
                if (node.@name == "File")
                {
                    result["file"] = infoClass['File'];
                }
                else
                {
                    result["components"][node.@name] = infoClass[node.@name];
                }
            }
            return result;
        }

        static public function getMouseLocalPosition(root:DisplayObjectContainer, local:DisplayObjectContainer):Point
        {
            var globalPt:Point = new Point(root.stage.mouseX, root.stage.mouseY);
            var localPt:Point = local.globalToLocal(globalPt);
            return localPt;
        }

        static public function getGlobalToLocalPosition(globalPt:Point, local:DisplayObjectContainer):Point
        {
            var localPt:Point = local.globalToLocal(globalPt);
            return localPt;
        }

        static public function getLocalToGlobalPosition(localPt:Point, local:DisplayObjectContainer):Point
        {
            var globalPt:Point = local.localToGlobal(localPt);
            return globalPt;
        }

        public static function playSound(url:String):SoundChannel
        {
            var snd:Sound = new Sound();
            var urlReq:URLRequest = new URLRequest(url);
            snd.load(urlReq);
            return snd.play();
        }
    }
}
