Ext.define('Ext.form.field.MultipleFile', {
    extend: 'Ext.form.field.File',
    alias: 'widget.multiplefilefield',

    multiple: true,

    /**
     * @private
     */
    onRender: function() {
        var me = this;
      
        if(me.multiple){  
        	me.on('afterrender', function () {
        		me.setMultiple();
        	}, me);
        }
        
        me.callParent(arguments);
    },
    
    reset: function() {
    	var me = this;
    	me.callParent(arguments);
    	me.setMultiple();
    },
    
    setMultiple: function (inputEl) {
    	var me = this;
        inputEl = inputEl || me.fileInputEl;
        inputEl.dom.setAttribute('multiple', 'multiple');
    },
    
    getFileList: function () {
    	var me = this;
        return me.fileInputEl.dom.files;
    }
});