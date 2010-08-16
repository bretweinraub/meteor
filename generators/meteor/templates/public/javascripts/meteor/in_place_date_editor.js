// -*-c-*-

// IE: Problem (http://www.railsforum.com/viewtopic.php?pid=53871)

Ajax.InPlaceDateEditor = Class.create();
Object.extend(Object.extend(Ajax.InPlaceDateEditor.prototype,
			    Ajax.InPlaceEditor.prototype), {
  createEditField: function() {
    var text;

    text = this.getText();

    var obj = this;

    this.options.textarea = false;
    var textField = document.createElement("input");
    textField.obj = this;
    textField.type = "text";
    textField.name = this.options.paramName;
    textField.value = text;

    var id;

    id = this.options.paramName + "_input_id";

    textField.id = id;
    textField.style.backgroundColor = this.options.highlightcolor;
    textField.className = 'editor_field';
    var size = this.options.size || this.options.cols || 0;
    if (size != 0) textField.size = size;
    if (this.options.submitOnBlur)
        textField.onblur = this.onSubmit.bind(this);
    this.editField = textField;

    this._form.appendChild(this.editField);

    var img = document.createElement("img");
    img.src = "/images/meteor/dhtml_calendar/calendar.gif";
    var img_id;
    img_id = this.options.paramName + "_date_picker_img";
    img.id = img_id;
    img.onmouseout = function() {this.style.backgroundColor='';};
    img.onmouseover = function()
    {
	this.style.backgroundColor = 'red';
    };
    img.title="Date selector";
    img.style.border = "1px solid blue";
    img.style.cursor = "pointer";
    img.style.pointer = "float:right";

    this._controls.editor = this.editField;
    this._form.appendChild(img);
  },

  enterEditMode: function(e) {
    if (this._saving || this._editing) return;
    this._editing = true;
    this.triggerCallback('onEnterEditMode');
    if (this.options.externalControl)
      this.options.externalControl.hide();
    this.element.hide();
    this.createForm();
    this.element.parentNode.insertBefore(this._form, this.element);
    if (!this.options.loadTextURL)
      this.postProcessEditField();
    Calendar.setup({inputField : this.options.paramName + '_input_id', ifFormat : "%Y-%m-%d", button : this.options.paramName + '_date_picker_img', align : "Tl", singleClick : true});
    if (e) Event.stop(e);
  }
});
