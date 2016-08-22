Ext.define('HreRem.view.common.adjuntos.AdjuntarFotoController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.adjuntarfoto',
       
    
    onClickBotonAdjuntarFoto: function(btn) {
    	
    	var me = this,
    	window = btn.up("window"),
    	form = window.down("form");
    	
    	
    	if(form.isValid()){
            
            var tienePrincipal = false;

            var fotosActuales = btn.up('window').parent.up('form').down('dataview').getStore().data.items;
            for (i=0; i < fotosActuales.length; i++) {
            	
            	if (form.getForm().getValues().principal == true 
            		&& fotosActuales[i].data.principal == 'true'
            		&& form.getForm().getValues().interiorExterior.toString() == fotosActuales[i].data.interiorExterior
				) {
            		tienePrincipal = true;
            		i=fotosActuales.length;
            	}
            	
            }
            
           
	            if (!tienePrincipal) {
	            	
	            	// Usado para subdivisiones, ya que el idEntidad se setea cuando se realiza el select en la combo de subdivision.
	            	if (window.idEntidad == null) {
	            		me.fireEvent("errorToast", "Debe seleccionar una subdivision");
	            	} else {
	            	
			            form.submit({
			                waitMsg: HreRem.i18n('msg.mask.loading'),
			                params: {idEntidad: window.idEntidad},
			                success: function(fp, o) {
		
			                    me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			                    window.hide();
			                    if(!Ext.isEmpty(window.parent)) {
			                    	if (window.parent.up('form').dataViewAlternativo != null) {
			                    		if (window.parent.up('form').idEntidadToLoad) {
											window.parent.up('form').down('[reference=' + window.parent.up('form').dataViewAlternativo + ']').getStore().getProxy().setExtraParams({'id':window.idEntidad}); 			
			                    		}
			                    		window.parent.up('form').down('[reference=' + window.parent.up('form').dataViewAlternativo + ']').getStore().load();
			                    	} else {
			                    		window.parent.up('form').down('dataview').getStore().load();
			                    	}
			                    	
			                    	//window.parent.fireEvent("afterUploadFoto", window.parent);
			                    }
			                }
			            });
			        }
	         } else {
	         	
	         		me.fireEvent("errorToast", "Ya dispone de una foto principal");
	         } 
    	}
    },
    
    onClickBotonAdjuntarFotoSubdivision:function (btn) {
    	
    	var me = this,
    	window = btn.up("window"),
    	form = window.down("form");
    	if(form.isValid()){            
          	
            form.submit({
                waitMsg: HreRem.i18n('msg.mask.loading'),
                params: {agrId: window.idAgrupacion, id: window.idSubdivision},
                success: function(fp, o) {
                    me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                    window.parentToRefresh.down("[reference=imageDataViewSubdivision]").getStore().load();
                    window.hide();                  
                }
            });
		 }
    }

});