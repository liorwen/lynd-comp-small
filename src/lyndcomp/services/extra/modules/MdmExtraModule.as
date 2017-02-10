/**
 * Created by zear19st on 2016/12/29.
 */
package lyndcomp.services.extra.modules
{
    import flash.utils.setTimeout;

    import mdm.*;

    public class MdmExtraModule extends ExtraModule
    {


        public function MdmExtraModule(type:String, root:*, weight:int)
        {
            super(type, root, weight);
        }

        override protected function init(root:*):void
        {
            Application.init(root, onInit);
        }

        private function onInit():void
        {
            if (!canBeUsed())
                return;
            Flash.allowScale(true, true);
            Flash.setShowAllMode();
            var maximizeFn:Function = function (myObject:*):void
            {
                Application.onFormMaximize = null;
                fullScreen(true);
                setTimeout(function ():void
                {

                    Application.onFormMaximize = maximizeFn
                }, 100);
            };

            Application.onFormMaximize = maximizeFn;

            var restoreFn:Function = function (myObject:*):void
            {
                Application.onFormRestore = null;
                fullScreen(false);
                setTimeout(function ():void
                {
                    Application.onFormRestore = restoreFn
                }, 100);
            };

            Application.onFormRestore = restoreFn;
        }


        override public function canBeUsed():Boolean
        {
            var check:String = Application.path;
            if (check != "")
                return true;
            return false;
        }


        override public function getPath():String
        {
            return Application.path.replace('\\\\\\', '\\\\');
        }


        override public function getThisFormHeight():Number
        {
            return Forms.thisForm.height;
        }

        override public function getThisFormWidth():Number
        {
            return Forms.thisForm.width;
        }

        override public function prompt(message:String):void
        {
            Dialogs.prompt(message);
        }


        override public function fullScreen(isFullScreen:Boolean):void
        {
            Forms.thisForm.hideCaption(false);
            if (isFullScreen)
            {
                Forms.thisForm.maximize();
                Forms.thisForm.hideCaption(true);
            }
            else
            {
                Forms.thisForm.restore();

            }
            _isFullScreen = isFullScreen;
            executeCallback(ExtraModule.CHANGE_SCREEN, {isFullScreen: _isFullScreen});
        }

        override public function folderExists(folderPath:String):Boolean
        {
            return FileSystem.folderExists(folderPath);
        }

        override public function getFileList(filePath:String, fileType:String):Array
        {
            return FileSystem.getFileList(filePath, fileType);
        }

        override public function exit():void
        {
            Application.exit();
        }

        override public function getCMDParams(cmdID:Number):String
        {
            return Application.getCMDParams(cmdID);
        }
    }
}
