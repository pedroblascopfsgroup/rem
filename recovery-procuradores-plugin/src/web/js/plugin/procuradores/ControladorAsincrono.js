Ext.ns("es.pfs.plugins.procuradores");

es.pfs.plugins.procuradores.ControladorAsincrono = Ext.extend(Object,{  //Step 1  
    
	attrb: "att1",  
	formulario: "form",
      
    constructor : function(options){    //Step 2
    	if (options==undefined) options = {};
        Ext.apply(this,options || {});  
      
//        console.debug("ControladorAsincrono constructor!");  
    },
    
    nuevoProceso: function(idTipoOperacion, form, funcionCallBack){
		this.formulario = form;
		debugger;
		//var idTipoOperacion = 1;//form.findField('id').getValue();
		var nombreFichero = form.findField('path').getValue().replace("C:\\fakepath\\", "");
		Ext.Ajax.request({
			url: '/pfs/msvprocesadotareasarchivo/initProcess.htm'
				,params: {idTipoOperacion: idTipoOperacion, nombreFichero: nombreFichero}
				,method: 'POST'
				,fn: funcionCallBack
				,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//debugger;
				request.fn(r);
				//fn.apply(r);
				//r.id;
				//this.uploadExcel(r.id);	 
				 }
				 ,error : function (result, request){
					alert("error nuevoProceso");
					 }
		});
    },
    validarFichero: function(idProceso, funcionCallBack){
		//debugger;
		//var idTipoOperacion = form.findField('id').getValue();
		Ext.Ajax.request({
			url: '/pfs/msvprocesadotareasarchivo/validarFichero.htm'
				,params: {idProceso: idProceso}
				,method: 'POST'
				,fn: funcionCallBack
				,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//debugger;
				request.fn(r);
				//fn.apply(r);
				//r.id;
				//this.uploadExcel(r.id);	 
				 }
				 ,error : function (result, request){
					alert("error validaFichero");
					 }
		});
    },
    liberarFichero: function(idProceso, funcionCallBack){
		//debugger;
		//var idTipoOperacion = form.findField('id').getValue();
		Ext.Ajax.request({
			url: '/pfs/msvprocesadotareasarchivo/liberarFichero.htm'
				,params: {idProceso: idProceso}
				,method: 'POST'
				,fn: funcionCallBack
				,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//debugger;
				request.fn(r);
				//fn.apply(r);
				//r.id;
				//this.uploadExcel(r.id);	 
				 }
				 ,error : function (result, request){
					alert("error liberarFichero");
					 }
		});
    },
    eliminarFichero: function(idProceso, funcionCallBack){
		//debugger;
		//var idTipoOperacion = form.findField('id').getValue();
		Ext.Ajax.request({
			url: '/pfs/msvprocesadotareasarchivo/eliminarArchivo.htm'
				,params: {idProceso: idProceso}
				,method: 'POST'
				,fn: funcionCallBack
				,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//debugger;
				request.fn(r);
				//fn.apply(r);
				//r.id;
				//this.uploadExcel(r.id);	 
				 }
				 ,error : function (result, request){
					alert("error eliminarArchivo");
					 }
		});
    }, 
    subirExcel: function(upload, f1){
		//debugger;
		//var idTipoOperacion = this.formulario.findField('id').getValue();
		Ext.Ajax.request({
			url: '/pfs/msvprocesadotareasarchivo/uploadFile.htm'
				,params: {}
				,isUpload:true
				,form: upload.getForm()
				,method: 'POST'
				,fn: f1
				,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//debugger;
				request.fn(r);
				//fn.apply(r);
				//r.id;
				//this.uploadExcel(r.id);	 
				 }
				 ,error : function (result, request){
					alert("error nuevoProceso");
					 }
		});
    },
    
    uploadExcel: function(idTipoOperacion, idProceso, upload, funcionCallBack,errorCallBack){
        if(upload.getForm().isValid()){
        	//alert(idProceso + "/" + idTipoOperacion)
        	//debugger;
        	upload.getForm().findField('idProceso').setValue(idProceso);
        	upload.getForm().findField('idTipoOperacion').setValue(idTipoOperacion);
            upload.getForm().submit({
                url:'plugin.masivo.upload.uploadFicheroParaProcesar.htm'
                ,waitMsg: '<s:message code="fichero.upload.subiendo" text="**Subiendo fichero..." />'
                ,success: function(upload, o){
                	//debugger;
                	funcionCallBack();
                }
            	,failure: function(){
            		if (errorCallBack){
            			errorCallBack();
            		}else{
            			Ext.Msg.alert('Error', 'Ha ocurrido un error inesperado en uploadExcel');
            		}
            	}
            });
        }
    },
    
    uploadExcelAjax: function(idTipoOperacion, idProceso, upload, funcionCallBack, errorCallBack){
        if(upload.getForm().isValid()){
        	upload.getForm().findField('idProceso').setValue(idProceso);
        	upload.getForm().findField('idTipoOperacion').setValue(idTipoOperacion);
    		Ext.Ajax.request({
				url:'plugin.masivo.upload.uploadFicheroParaProcesar.htm'
				,params: {}
				,headers: {'Content-type':'multipart/form-data'}
				,isUpload:true
				,form: upload.getForm().getEl().dom
				,method: 'POST'
				,fnOk: funcionCallBack
				,fnError: errorCallBack
				,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				request.fnOk(r);
				 }
				 ,error : function (result, request){R
					alert("error nuevoProceso");
					var r = Ext.util.JSON.decode(result.responseText);
					request.fnError(r);
				}
    		});        	

        }
    },    
    
    uploadFicheroResolucion: function(upload, funcionCallBack, errorCallBack){
        if(upload.getForm().isValid()){
        	//alert(idProceso + "/" + idTipoOperacion)
        	//upload.getForm().findField('idResolucion').setValue(idResolucion);
            upload.getForm().submit({
                url:'plugin.masivo.upload.uploadFicheroResoluciones.htm'
                ,waitMsg: '<s:message code="fichero.upload.subiendo" text="**Subiendo fichero..." />'
                ,success: function(upload, o){
                	debugger;
                	funcionCallBack(o.result);
                }
            	,failure: function(){
            		if (errorCallBack){
            			errorCallBack();
            		}else{
            			Ext.Msg.alert('Error', 'Ha ocurrido un error inesperado en uploadExcel');
            		}
            	}
            });
        }
    },
    
    uploadFicheroAjax: function(form, funcionCallBack, errorCallBack){
        if(form.getForm().isValid()){
    		Ext.Ajax.request({
    				url:'plugin.masivo.upload.genericUploadFichero.htm'
    				,params: {}
    				,headers: {'Content-type':'multipart/form-data'}
    				,isUpload:true
    				,form: form.getForm().getEl().dom
    				,method: 'POST'
    				,fnOk: funcionCallBack
    				,fnError: errorCallBack
    				,success: function (result, request){
    				var r = Ext.util.JSON.decode(result.responseText);
    				request.fnOk(r);
    				 }
    				 ,error : function (result, request){
    					alert("error nuevoProceso");
    					var r = Ext.util.JSON.decode(result.responseText);
    					request.fnError(r);
    				}
    		});        	
        }
    },    
    
    uploadFicheroResolucionTareas: function(upload, funcionCallBack, errorCallBack){
        if(upload.getForm().isValid()){
        	//alert(idProceso + "/" + idTipoOperacion)
        	debugger;
        	//upload.getForm().findField('idResolucion').setValue(idResolucion);
            upload.getForm().submit({
                url:'plugin.masivo.upload.genericUploadFichero.htm'
                ,waitMsg: '<s:message code="fichero.upload.subiendo" text="**Subiendo fichero..." />'
                ,success: function(upload, o){
                	debugger;
                	funcionCallBack(o.result);
                }
            	,failure: function(){
            		if (errorCallBack){
            			errorCallBack();
            		}else{
            			Ext.Msg.alert('Error', 'Ha ocurrido un error inesperado en uploadExcel');
            		}
            	}
            });
        }
    },
    
    
    
    subirFichero: function(form){
		//debugger;
		this.nuevoProceso(form);
		//this.upload();
    	
    },
    
    recargarAyuda: function(idTipoResolucion, funcionCallBack){
		//debugger;
		Ext.Ajax.request({
			url: '/pfs/pcdprocesadoresoluciones/dameAyuda.htm'
				,params: {idTipoResolucion: idTipoResolucion}
				,method: 'POST'
				,fn: funcionCallBack
				,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				request.fn(r);
				 }
				 ,error : function (result, request){
					alert("error recargarAyuda");
					 }
		});
    }, 
    
    procesarResolucion: function(idResolucion, funcionCallBack){
		//debugger;
		//var idTipoOperacion = form.findField('id').getValue();
		Ext.Ajax.request({
			url: '/pfs/pcdprocesadoresoluciones/procesarResolucion.htm'
				,params: {idResolucion: idResolucion}
				,method: 'POST'
				,fn: funcionCallBack
				,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//debugger;
				request.fn(r);
				//fn.apply(r);
				//r.id;
				//this.uploadExcel(r.id);	 
				 }
				 ,error : function (result, request){
					alert("error procesarResolucion");
					 }
		});
    }

});