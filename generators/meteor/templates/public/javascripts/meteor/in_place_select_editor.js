// -*-c-*-

// IE: Problem (http://www.railsforum.com/viewtopic.php?pid=53871)

Ajax.InPlaceSelectEditor = Class.create();
Object.extend(Object.extend(Ajax.InPlaceSelectEditor.prototype,
			    Ajax.InPlaceEditor.prototype), {
 createEditField: function() {
   var text;
   if(this.options.loadTextURL) {
     text = this.options.loadingText;
   } else {
     text = this.getText();
   }
   this.options.textarea = false;
   var selectField = document.createElement("select");
   selectField.name = "value";
   selectField.innerHTML=this.options.selectOptionsHTML ||
     "<option>" + text + "</option>";
   $A(selectField.options).each(function(opt, index){
     if(text == opt.value) {
       selectField.selectedIndex = index;
     }
   });
   selectField.style.backgroundColor = this.options.highlightcolor;
   this.editField = selectField;
   //   this._controls.editor = selectField;
   if(this.options.loadTextURL) {
     this.loadExternalText();
   }
   this.form.appendChild(this.editField);
   //   this._form.appendChild(this._controls.editor);
 }
});
