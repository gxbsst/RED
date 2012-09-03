// Preview at agreement and downloads.
function preview(form, controller) {
  if (Element.visible('preview-content')) {
    new Effect.SlideUp('preview-content', {duration: 0.25});
    return false;
  }
  new Ajax.Updater('preview-content', '/' + controller + '/preview', {asynchronous:true, evalScripts:true, onComplete:function() {new Effect.BlindDown('preview-content', {duration: 0.25})},parameters:Form.serialize(form)});
}
