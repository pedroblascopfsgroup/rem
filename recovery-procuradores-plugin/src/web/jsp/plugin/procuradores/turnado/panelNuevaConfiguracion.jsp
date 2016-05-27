	<%-- Variable auxiliares --%>
	var nuevasPlazasConfig = [];
	var idsTuplasConfig = [];
	<%-- Seleccion de plazas --%>
	
	var busquedaActivaPlazas = false;
	<%-- Store del combo de plazas --%>
	var listadoPlazasStore = page.getStore({
		flow:'turnadoprocuradores/getPlazasInstant'
	        ,remoteSort:false
	        ,autoLoad: false
	        ,reader : new Ext.data.JsonReader({
	            root:'data'
	            ,fields:['id','codigo','descripcion']
	        })
    });
    
    
    listadoPlazasStore.on('beforeload', function(store, options){
    	if (busquedaActivaPlazas){
    		return false;
    	} else{
    		busquedaActivaPlazas = true;
    	}
    });
    
    listadoPlazasStore.on('load', function(store, records, options){
    	busquedaActivaPlazas = false;
    });

    var cmbPlazas = new Ext.form.ComboBox({
        name : 'turnadoProcuComboPlazas'
        ,valueField: 'codigo' 
        ,displayField:'descripcion'
        ,store: listadoPlazasStore
        ,fieldLabel : '<s:message code="plugin.procuradores.turnado.plaza" text="**Plazas" />'
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,width : 193
        ,allowBlank:false
        ,enableKeyEvents: true
        ,typeAhead: false   
        ,minChars: 3
        ,maxLength:256 
        ,queryDelay: 800
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,listeners: {
			select: function(){
				dimeSiPlazaYaSeleccionada(this.getValue());
			}
		}
    });
  
    <%--Boton añadir plaza--%>
	var botonAddPlaza = new Ext.Button({
        iconCls:'icon_mas'
        ,disabled : true
        ,handler : function(){
        	if(cmbPlazas.getValue().trim()!='' && cmbPlazas.getValue()!=null){
        		var plazaItem = listadoPlazasStore.getAt(listadoPlazasStore.find('codigo', cmbPlazas.getValue()));
			  	//Llamar funcion añadir plaza nueva config
			  	añadirNuevaPlazaConfigEsquema(plazaItem);
   	    	}		
		}
    });
    
    <%--Boton eliminar plaza--%>
	var botonRemovePlaza = new Ext.Button({
        iconCls:'icon_menos'
        ,disabled : true
        ,handler: function(){
        	if(cmbPlazas.getValue().trim()!='' && cmbPlazas.getValue()!=null){
        		var plazaItem = listadoPlazasStore.getAt(listadoPlazasStore.find('codigo', cmbPlazas.getValue()));	
        		//Llamar funcion eliminar plaza config
        		borrarPlazaConfigEsquema(plazaItem.get('codigo'));
			}
        }
    });
    
    <%-- Funcion validar si plaza ya seleccionada --%>
    var dimeSiPlazaYaSeleccionada = function(codigoPlaza){
    	var flag;
    	var plazaItem = Ext.getCmp('turn_procu_lista_plazas').find('name','plaza_'+codigoPlaza);
    	if(plazaItem.length>0) flag=true;
    	else flag=false;
		botonAddPlaza.setDisabled(flag);
		botonRemovePlaza.setDisabled(!flag);	
    }
    
	var plazasPanel = app.creaPanelHz({style : "margin-top:4px;margin-bottom:4px;"},[{html:"<b><s:message code="plugin.procuradores.turnado.plaza" text="**Plazas" /></b>"+":", border: false, width : 133, cls: 'x-form-item', style: "margin-top:4px;"},cmbPlazas, botonAddPlaza, botonRemovePlaza]);
	
	<%-- Fin seleccion de plazas --%>
	
	<%-- Seleccion de procedimientos --%>
	
	var busquedaActivaTPO = false;
	<%-- Store del combo de tpos --%>
	var listadoTPOStore = page.getStore({
		flow:'turnadoprocuradores/getTPOsInstant'
	        ,remoteSort:false
	        ,autoLoad: false
	        ,reader : new Ext.data.JsonReader({
	            root:'data'
	            ,fields:['id','codigo','descripcion']
	        })
    });
    
    
    listadoTPOStore.on('beforeload', function(store, options){
    	if (busquedaActivaTPO){
    		return false;
    	} else{
    		busquedaActivaTPO = true;
    	}
    });
    
    listadoTPOStore.on('load', function(store, records, options){
    	busquedaActivaTPO = false;
    });

    var cmbTPO = new Ext.form.ComboBox({
        name : 'turnadoProcuComboTPO'
        ,valueField: 'codigo' 
        ,displayField:'descripcion'
        ,store: listadoTPOStore
        ,fieldLabel : '<s:message code="plugin.procuradores.turnado.tipoProcedimiento" text="**Tipo procedimiento" />'
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,width : 193
        ,allowBlank:false
        ,enableKeyEvents: true
        ,typeAhead: false   
        ,minChars: 3
        ,maxLength:256 
        ,queryDelay: 800
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,listeners: {
			select: function(){
				dimeSiTPOYaSeleccionado(this.getValue());
			}
		}
    });
  
    <%--Boton añadir tpo--%>
	var botonAddTPO = new Ext.Button({
        iconCls:'icon_mas'
        ,disabled : true
        ,handler : function(){
        	if(cmbTPO.getValue().trim()!='' && cmbTPO.getValue()!=null){
        		var tpoItem = listadoTPOStore.getAt(listadoTPOStore.find('codigo', cmbTPO.getValue()));
			  	//Llamar funcion añadir tpo config
			  	addNuevoTPOConfigEsquema(tpoItem);
   	    	}		
		}
    });
    
    <%--Boton eliminar tpo--%>
	var botonRemoveTPO = new Ext.Button({
        iconCls:'icon_menos'
        ,disabled : true
        ,handler: function(){
        	if(cmbTPO.getValue().trim()!='' && cmbTPO.getValue()!=null){
        		var tpoItem = listadoTPOStore.getAt(listadoTPOStore.find('codigo', cmbTPO.getValue()));	
				//Llamar funcion eliminar tpo config
				borrarTPOConfigEsquema(tpoItem.get('codigo'));
			}
        }
    });
    
    <%-- Funcion validar si tpo ya seleccionado --%>
    var dimeSiTPOYaSeleccionado = function(codigoTPO){
    	var flag;
    	var tpoItem = Ext.getCmp('turn_procu_lista_procedimientos').find('name','tpo_'+codigoTPO);
    	if(tpoItem.length>0) flag=true;
    	else flag=false;
		botonAddTPO.setDisabled(flag);
		botonRemoveTPO.setDisabled(!flag);	
    }
    
	var plazasPanel = app.creaPanelHz({style : "margin-top:4px;margin-bottom:4px;"},[{html:"<b><s:message code="plugin.procuradores.turnado.plaza" text="**Plazas" /></b>"+":", border: false, width : 133, cls: 'x-form-item', style: "margin-top:4px;"},cmbPlazas, botonAddPlaza, botonRemovePlaza]);
	var procedimientoPanel = app.creaPanelHz({style : "margin-top:4px;margin-bottom:4px;"},[{html:"<b><s:message code="plugin.procuradores.turnado.tipoProcedimiento" text="**Tipo procedimiento" /></b>"+":", border: false, width : 133, cls: 'x-form-item', style: "margin-top:4px;"},cmbTPO,botonAddTPO,botonRemoveTPO]);
	
	<%-- Fin seleccion de procedimientos --%>
	
	<%-- Panel nueva configuracion--%>
    var infoConfiguracionTurnado = new Ext.form.FieldSet({
    	title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelLitigios.titulo**" text="**Configurar plazas y procedimientos" />'
		,layout:'table'
		,autoHeight:true
		,border:true
		,hidden: true
		,collapsible : true
		,collapsed : false
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 2 }
		,defaults :  {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px', width:400 }
		,items:[{items:[plazasPanel,
		 			{
	                title : ''
	                ,layout:'table' 
	                ,border : true
	                ,layoutConfig: { columns: 2 }
	                ,autoScroll:true
	                ,bodyStyle:'padding:5px;'
	                ,name: 'turn_procu_lista_plazas'
	                ,id:'turn_procu_lista_plazas'
	                //,autoHeight:true
	                //,autoWidth : true
	                ,height: 100
	                ,width:375
            		}]}
		 	,{items:[procedimientoPanel,
		 			{
	                title : ''
	                ,layout:'table' 
	                ,border : true
	                ,layoutConfig: { columns: 2 }
	                ,autoScroll:true
	                ,bodyStyle:'padding:5px;'
	                ,name: 'turn_procu_lista_procedimientos'
	                ,id:'turn_procu_lista_procedimientos'
	                //,autoHeight:true
	                //,autoWidth : true
	                ,height: 100
	                ,width:375
            		}]}			
			,{items:[{xtype:'hidden',name:'plazasConfigNueva',value:''},{xtype:'hidden',name:'tpoConfigNueva',value:''},{xtype:'hidden',name:'idRangosConfigNueva',value:''}]}
				]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(900-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	}); 
	
	<%-- Funciones --%>
	var añadirNuevaPlazaConfigEsquema = function(plazaItem){
		//Comprobar que no exista ya configuracion existente para dicha plaza
		Ext.Ajax.request({
			url: '/pfs/turnadoprocuradores/checkSiPlazaYaTieneConfiguracion.htm'
			,params: {
						plazaCod: plazaItem.get('codigo')
						,idEsquema: idEsquema
					}
			,method: 'POST'
			,success: function (result, request){
				//Añadir codigo al array de codigo de plazas
				nuevasPlazasConfig.push(plazaItem.get('codigo'));
				
				//Crear objetos dinamicos
				var campo = new Ext.form.Label({
	  	   				name: 'plaza_'+plazaItem.get('codigo'),
		   				html:  plazaItem.get('descripcion')+ '&nbsp;',
		   				width:250,
		   				style: 'font-size:12px;'
	   	    	}); 
	   	    	var borrarCampo = new Ext.form.Label({
					   name: 'borrarPlaza_'+plazaItem.get('codigo'),
					   html: '<img src="/${appProperties.appName}/img/plugin/masivo/icon_trash.png"/>',
			  		   style: 'float:left;font-size:12px;margin-left:2px;',
			  		   listeners: {
			  		   		render: function(c){
			  		   			c.getEl().on({
			  		   				click: function(el){
		  		   						var plazaValue = this.name.split('_')[1];
		  		   						//Llamar funcion eliminar plaza config
		  		   						borrarPlazaConfigEsquema(plazaValue);
			  		   				},scope: c
			  		   			});
			  		   		}
			   		   }
		  		});
		  		var panel = Ext.getCmp('turn_procu_lista_plazas');
			    panel.add(campo);
			   	panel.add(borrarCampo);
			  	panel.doLayout();
			  	dimeSiPlazaYaSeleccionada(plazaItem.get('codigo'));
			  	
			  	//Webflob para cargar el grid
				rangosStore.webflow({idEsquema : idEsquema,  idPlaza : '', idTPO : ''});
			}
			,error: function(result, request){
				alert("Error comprobando si ya existe configuracion para la plaza seleccionada");
			}
		});
	}
	
	var borrarPlazaConfigEsquema = function(itemCod){
		Ext.Ajax.request({
			url: '/pfs/turnadoprocuradores/borrarConfigParaPlazaOTpo.htm'
			,params: {
						plazaCod: itemCod
						,idEsquema: idEsquema
					}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//Eliminar codigo del array de codigo de plazas
				var index = nuevasPlazasConfig.indexOf(itemCod);
				if(index > -1) nuevasPlazasConfig.splice(index, 1);
				
				//Eliminar ids tuplas eliminadas de el array que guarda ids
				for(var i=0; i< r.idTuplas.length; i++){
					var index = idsTuplasConfig.indexOf(r.idTuplas[0].idTupla);
					if(index > -1) idsTuplasConfig.splice(index, 1);
				}
				
				//Borrar objetos dinamico
				var cmp = Ext.getCmp('turn_procu_lista_plazas').find('name','plaza_'+itemCod)[0];
				cmp.destroy();
				cmp = Ext.getCmp('turn_procu_lista_plazas').find('name','borrarPlaza_'+itemCod)[0];
				cmp.destroy();
				dimeSiPlazaYaSeleccionada(itemCod);
				
				//Webflob para cargar el grid
				rangosStore.webflow({idEsquema : idEsquema,  idPlaza : '', idTPO : ''});
			}
			,error: function(result, request){
				alert("Error borrando");
			}
		});
	}
	
	var addNuevoTPOConfigEsquema = function(tpoItem){
		Ext.Ajax.request({
			url: '/pfs/turnadoprocuradores/addNuevoTPOPlazas.htm'
			,params: {
						codTPO: tpoItem.get('codigo')
						,idEsquema: idEsquema
						,arrayPlazas : nuevasPlazasConfig
					}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//Guardar ids tuplas por si se cancela operacion
				for(var i=0; i< r.idTuplas.length; i++){
					idsTuplasConfig.push(r.idTuplas[0].idTupla);
				}
		
				//Crear objetos dinamicos
				var campo = new Ext.form.Label({
	  	   				name: 'tpo_'+tpoItem.get('codigo'),
		   				html:  tpoItem.get('descripcion')+ '&nbsp;',
		   				width:250,
		   				style: 'font-size:12px;'
	   	    	}); 
	   	    	var borrarCampo = new Ext.form.Label({
				   name: 'borrarTpo_'+tpoItem.get('codigo'),
				   html: '<img src="/${appProperties.appName}/img/plugin/masivo/icon_trash.png"/>',
		  		   style: 'float:left;font-size:12px;margin-left:2px;',
		  		   listeners: {
		  		   		render: function(c){
		  		   			c.getEl().on({
		  		   				click: function(el){
		  		   					var tpoValue = this.name.split('_')[1];
		  		   					//Llamar funcion eliminar tpo config
		  		   					borrarTPOConfigEsquema(tpoValue);
		  		   				},scope: c
		  		   			});
		  		   		}
		   		   }
		  		});
		  		
		  		var panel = Ext.getCmp('turn_procu_lista_procedimientos');
			    panel.add(campo);
			   	panel.add(borrarCampo);
			  	panel.doLayout();
			  	dimeSiTPOYaSeleccionado(tpoItem.get('codigo'));
			  	
			  	//Webflob para cargar el grid
			  	rangosStore.webflow({idEsquema : idEsquema,  idPlaza : '', idTPO : ''});
			}
			,error: function(result, request){
				alert("Error guardando");
			}
		});
	}
	
	var borrarTPOConfigEsquema = function(tpoValue){
		Ext.Ajax.request({
			url: '/pfs/turnadoprocuradores/borrarConfigParaPlazaOTpo.htm'
			,params: {
						tpoCod: tpoValue
						,idEsquema: idEsquema
						,arrayPlazas : nuevasPlazasConfig
					}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//Eliminar ids tuplas eliminadas de el array que guarda ids
				for(var i=0; i< r.idTuplas.length; i++){
					var index = idsTuplasConfig.indexOf(r.idTuplas[0].idTupla);
					if(index > -1) idsTuplasConfig.splice(index, 1);
				}
				//Borrar objetos dinamicos
				var cmp = Ext.getCmp('turn_procu_lista_procedimientos').find('name','tpo_'+tpoValue)[0];
				cmp.destroy();
				cmp = Ext.getCmp('turn_procu_lista_procedimientos').find('name','borrarTpo_'+tpoValue)[0];
				cmp.destroy();
				dimeSiTPOYaSeleccionado(tpoValue);
					
				//Webflob para cargar el grid
				rangosStore.webflow({idEsquema : idEsquema,  idPlaza : '', idTPO : ''});
			}
			,error: function(result, request){
				alert("Error borrando");
			}
		});
	}