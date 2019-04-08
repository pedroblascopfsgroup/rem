Ext.define('HreRem.view.common.WindowBase', {
    extend		: 'Ext.window.Window',
    xtype		: 'windowBase',
    cls	: 'window-base',
    border: false,
    modal	: true,
    bodyPadding: 10,
    closable: false,
    
    initComponent: function() {  
    	var me = this;
   		me.callParent();
    },
    
    hideWindow: function() {
    	var me = this;    	
    	me.hide();   	
    },
    
    closeWindow: function() {
    	var me = this;
    	me.close();   	
    },
    onClickBotonAdjuntarDocumento: function(btn) {
		
    	var me = this,
    	params = {},
    	form = me.down("form");
    	if(form.isValid()){
    		var url= $AC.getRemoteUrl('activo/getLimiteArchivo');
    		var data;
    		Ext.Ajax.request({
    		     url: url,
    		     success: function(response, opts) {
    		    	 data = Ext.decode(response.responseText);
    		    	 if(data.sucess == "true"){
    		    		 
    		    		 var limite = data.limite;
    		    		 params = {idEntidad: me.idEntidad};
    		     		if(Ext.isDefined(me.down('gridBase')) && me.down('gridBase') != null){
    		     			var comboSubtipoDocumento = form.down("[name=subtipo]"); 
    		         		var subtipoDocumento = comboSubtipoDocumento.findRecordByValue(comboSubtipoDocumento.getValue());
    		         		var activosSeleccionados = [];
    		 	    		Ext.Array.each(me.down('gridBase').getSelection(), function(selected, index) {
    		 	    		 	activosSeleccionados.push(selected.get("numActivo"));
    		 	    		});
    		 	    		params = {idEntidad: me.idEntidad, activos: activosSeleccionados.toString()};
    		     		}
    		             form.submit({
    		                 waitMsg: HreRem.i18n('msg.mask.loading'),
    		                 params: params,
    		                 success: function(fp, o) {

    		                 	if(o.result.success == "false") {    		                 		
    		                 		me.fireEvent("errorToast", HreRem.i18n("msg.falta.permisos"));
    		                 	}else{
    		                 		me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
    		                 	}
    		                 	if(!Ext.isEmpty(me.parent)) {
    		                 		me.parent.fireEvent("afterupload", me.parent);
    		                 	}
    		                     me.close();
    		                 },
    		                 failure: function(fp, o) {
    		                	if(o.response.statusText != 'transaction aborted'){
    		                 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    		                 	}
    		                 },
    		                 progress: function(action, progress, event) {

    		                 	if(limite > 0 && event.total/1000/1000 > limite){
    		                 		Ext.Ajax.getLatest().abort();
    		                 		me.fireEvent("errorToast", "No se puede subir ficheros mayores de "+limite+"Mb.");
    		                 		progress = 1;
    		                 	}
    		     	            Ext.Msg.updateProgress(progress);
    		     	        }
    		             });
    		             /**
    		         	 * HTML 5 File upload ProgressBar. This code introduces ability to monitor file upload progress in forms.
    		         	 * It provides the progress method to form action configuration for progress monitoring. Implementation is also
    		         	 * backward compatibile with browsers that do not implement the Html 5 File API. In such case the progress method
    		         	 * is just not going to be invoked.
    		         	 * 
    		         	 * Usage:
    		         	 * 
    		         	    Ext.Msg.wait("Uploading", "Your file is being uploaded")
    		         	    form.submit({
    		         	        url: '/upload',
    		         	        success: function() {
    		         	            Ext.Msg.alert('Success', 'Your file has been uploaded.');
    		         	        },
    		         	        //progress is [0..1], and event is the underlying HTML 5 progress event.
    		         	        progress: function(action, progress, event) {
    		         	            Ext.Msg.updateProgress(progress)
    		         	        }
    		         	    })
    		         	 * @overrides Ext.data.Connection
    		         	 * @author Maciej Szajna
    		         	 */
    		         	Ext.define('Ext.ux.data.Html5Connection', {
    		         	    override: 'Ext.data.Connection',
    		         	    
    		         	    /**
    		         	     * Override the Accept header to accept text/html. This is for compatibility if you want to support browsers
    		         	     * without Html 5 File API implemented. In such case your backend server needs to respond with text/html for
    		         	     * iframe to accept it. Then this implementation must accept text/html as well.
    		         	     * @cfg {Boolean} overrideAccept
    		         	     */
    		         	    overrideAccept: true,
    		         	    
    		         	    /**
    		         	     * Checks whether Html 5 File API is supported
    		         	     */
    		         	    isHtml5Supported: function() {return typeof FileReader != "undefined";},
    		         	    
    		         	    /**
    		         	     * If File API is supported, then do not treat upload forms specially.
    		         	     */
    		         	    isFormUpload: function(options) {
    		         	        return !this.isHtml5Supported() && this.callParent(arguments);
    		         	    },
    		         	    
    		         	    /**
    		         	     * Construction of FormData object.
    		         	     */
    		         	    setOptions: function(options, scope) {
    		         	        var opts = this.callParent(arguments);
    		         	        if (this.isHtml5Supported() && options.isUpload && options.form) {
    		         	            opts.data = new FormData(options.form);
    		         	        }
    		         	        return opts;
    		         	    },
    		         	    
    		         	    createRequest: function(options, requestOptions){
    		         	        var request = this.callParent(arguments);
    		         	        if (this.isHtml5Supported() && options.isUpload && options.progress){
    		         	            
    		         	            if (!options.headers) options.headers = {};
    		         	            options.headers['Content-Type'] = null;
    		         	        }
    		         	        
    		         	        return request;
    		         	    }
    		         	});
    		         	    
    		         	Ext.define('Ext.ux.data.Html5Request', {
    		         	    override: 'Ext.data.request.Ajax',
    		         	    /**
    		         	     * Registration of progress handler
    		         	     * @private
    		         	     */
    		         	    id: 'requestSubida',
    		         	    openRequest: function(options,  requestOptions, async, username, password) {
    		         	        var me = this;
    		         	        var xhr = this.callParent(arguments);
    		         	        if (options.isUpload && options.progress) {
    		         	            xhr.upload.onprogress = options.progress;
    		         	        }
    		         	        return xhr;
    		         	    },
    		         	    
    		         	    /**
    		         	     * Fix for text/html Accept header for backward compatibility.
    		         	     * @private
    		         	     */
    		         	    setupHeaders: function(xhr, options, data, params) {
    		         	        var acceptHeader = "Accept";
    		         	        if (this.overrideAccept && options.isUpload) {
    		         	            if (!options.headers) options.headers = {};
    		         	            options.headers[acceptHeader] = "text/html";
    		         	        }
    		         	        return this.callParent(arguments);
    		         	    }
    		         	});




    		         	/**
    		         	 * Passes progress callback to the Connection object.
    		         	 */
    		         	Ext.define('Ext.ux.form.action.Action', {
    		         	    override: 'Ext.form.action.Action',
    		         	    createCallback: function() {
    		         	        var me = this;
    		         	        var callback = this.callParent();
    		         	        callback.progress = function(e) {
    		         	        	
    		         	            var prog = e.loaded / e.total;
    		         	            Ext.callback(me.progress, me.scope || me, [me, prog, e]);
    		         	        };
    		         	        return callback;
    		         	    }
    		         	});
    		    	 }else{
        		    	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    		    	 }
    		         
    		     },
    		     failure: function(response) {
    		    	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    		     }
    		 });
    		

        }

    	

    }


});