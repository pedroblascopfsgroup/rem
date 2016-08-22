Ext.define('HreRem.view.common.ImageFieldBase', { 
    extend: 'Ext.form.field.Base',
    alias: 'widget.imagefield',
    fieldSubTpl: ['<img id="{id}" class="{fieldCls}"/>', {
        compiled: true,
        disableFormats: true
    }],

    fieldCls: Ext.baseCSSPrefix + 'form-image-field',
    value: null,
	src: null,

    initEvents: function () {
        this.callParent();

        //Adding the click event (can make other events here aswell)
        this.inputEl.on('click', this._click, this, {
            delegate: 'img.form-image-field'
        });

    },

    setValue: function (v) {
        var me = this;
        me.callParent(arguments);
        
        me.value = v;

        var imgEl = Ext.getDom(me.id+'-inputEl');
        if(!Ext.isEmpty(imgEl)) {
	        imgEl.src=v;
	        imgEl.width=me.width;
        }

        //Change ur image value here...
    },

    onRender: function () {
        var me = this;
        me.callParent(arguments);

        var name = me.name || Ext.id();

        me.hiddenField = me.inputEl.insertSibling({
            tag: 'input',
            type: 'hidden',
            name: name
        });
    },

    _click: function (e, o) {
        this.fireEvent('click', this, e);
    },
    
    
    getSrc: function() {
    	var me = this;
    	return me.src;
    },
    
    setSrc: function(value) {
    	var me = this;    	
    	me.src = value;
    	me.setValue(value)
    	
    }
});