	<%-- Variable auxiliares --%>
	var nuevasPlazasConfig = [];
	var idsTuplasConfig = [];
	var idsTuplasBorradasConfig = [];
	var idsRangosBorradosConfig = [];
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
	    	var existen = nuevasPlazasConfig.length>0;
       		listadoPlazasStore.setBaseParam('otrasPlazasPresentes', existen);
       		//Comprobamos que no este seleccionada plaza por defecto, de manera que si lo esta, solo nos muestre esta ()
       		var index = nuevasPlazasConfig.indexOf(-1);
       		var presente = index!=-1;
       		listadoPlazasStore.setBaseParam('plazaDefectoPresente', presente);
    		busquedaActivaPlazas = true;
    	}
    });
    
    listadoPlazasStore.on('load', function(store, records, options){
    	busquedaActivaPlazas = false;
    });

    var cmbPlazas = new Ext.form.ComboBox({
        name : 'turnadoProcuComboPlazas'
        ,valueField: 'id' 
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
        	if(cmbPlazas.getValue()!='' && cmbPlazas.getValue()!=null){
        		var plazaItem = listadoPlazasStore.getAt(listadoPlazasStore.find('id', cmbPlazas.getValue()));
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
        	if(cmbPlazas.getValue()!='' && cmbPlazas.getValue()!=null){
        		var plazaItem = listadoPlazasStore.getAt(listadoPlazasStore.find('id', cmbPlazas.getValue()));	
        		//Llamar funcion eliminar plaza config
        		borrarPlazaConfigEsquema(plazaItem.get('id'));
			}
        }
    });
    
    <%-- Funcion validar si plaza ya seleccionada --%>
    var dimeSiPlazaYaSeleccionada = function(idPlaza){
    	var flag;
    	var plazaItem = Ext.getCmp('turn_procu_lista_plazas').find('name','plaza_'+idPlaza);
    	if(plazaItem.length>0) flag=true;
    	else flag=false;
		botonAddPlaza.setDisabled(flag);
		botonRemovePlaza.setDisabled(!flag);	
    }
    
	var plazasPanel = app.creaPanelHz({style : "margin-top:4px;margin-bottom:4px;"},[{html:"<b><s:message code="plugin.procuradores.turnado.plaza" text="**Plazas" /></b>"+":", border: false, width : 133, cls: 'x-form-item', style: "margin-top:4px;"},cmbPlazas, botonAddPlaza, botonRemovePlaza]);
	
	<%-- Fin seleccion de plazas --%>
	
	<%-- Seleccion de procedimientos --%>
	
	<%-- Store del combo de tpos --%>
	var listadoTPOStore = page.getStore({
		flow:'turnadoprocuradores/getProcedimientosIniciadores'
	        ,reader : new Ext.data.JsonReader({
	            root:'data'
	            ,fields:['id','codigo','descripcion']
	        })
    });
    
    var cmbTPO = new Ext.form.ComboBox({
        name : 'turnadoProcuComboTPO'
        ,fieldLabel : '<s:message code="plugin.procuradores.turnado.tipoProcedimiento" text="**Tipo procedimiento" />'
        ,valueField: 'id' 
        ,displayField:'descripcion'
        ,store: listadoTPOStore
        ,mode: 'local'
		,emptyText:'----'
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,width : 193
        ,allowBlank:true
		,triggerAction: 'all'
        ,enableKeyEvents: true
        ,typeAhead: false
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
        	if(cmbTPO.getValue()!='' && cmbTPO.getValue()!=null){
        		var tpoItem = listadoTPOStore.getAt(listadoTPOStore.find('id', cmbTPO.getValue()));
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
        	if(cmbTPO.getValue()!='' && cmbTPO.getValue()!=null){
        		var tpoItem = listadoTPOStore.getAt(listadoTPOStore.find('id', cmbTPO.getValue()));	
				//Llamar funcion eliminar tpo config
				borrarTPOConfigEsquema(tpoItem.get('id'));
			}
        }
    });
    
    <%-- Funcion validar si tpo ya seleccionado --%>
    var dimeSiTPOYaSeleccionado = function(idTPO){
    	var flag;
    	var tpoItem = Ext.getCmp('turn_procu_lista_procedimientos').find('name','tpo_'+idTPO);
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
    	title : '<s:message code="plugin.procuradores.turnado.tapConfigurar" text="**Configurar plazas y procedimientos" />'
		,layout:'table'
		,autoHeight:true
		,border:true
		,hidden: true
		,collapsible : true
		,collapsed : true
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
		,listeners: {
			expand:  function(){
				turnadoFiltrosFieldSet.expand(true);
				nombreEsquemaPanel.collapse(true);
			}
		}		
		,doLayout:function() {
				var margin = 40;
				this.setWidth(900-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	}); 
	
	<%-- Funciones --%>
	var gestionarPanelNuevaPlaza = function(){
		var control = Ext.getCmp('turn_procu_lista_procedimientos').items.length>0;
		Ext.getCmp('turn_procu_lista_plazas').setDisabled(control);
		plazasPanel.setDisabled(control);
	}
	
	var gestionarPanelNuevoTPO = function(){
		var control = (rangosStore.data.length>0) || (nuevasPlazasConfig.length<=0);
		Ext.getCmp('turn_procu_lista_procedimientos').setDisabled(control);
		procedimientoPanel.setDisabled(control);
	}
	
	var añadirNuevaPlazaConfigEsquema = function(plazaItem){
		//Comprobar que no exista ya configuracion existente para dicha plaza
		Ext.Ajax.request({
			url: '/pfs/turnadoprocuradores/checkSiPlazaYaTieneConfiguracion.htm'
			,params: {
						idPlaza: plazaItem.get('id')
						,idEsquema: idEsquema
					}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				var confirmado = false;
				//Comprobar si ya existia o no para pedir confirmacion
				if(r.fwk!=null && r.fwk.fwkExceptions!=null && r.fwk.fwkExceptions[0]!=null){
					//Si confirma afirmativo, persistir la plaza con todos los tpos disponibles	
					Ext.Msg.minWidth=360;	
					Ext.Msg.confirm('<s:message code="plugin.procuradores.turnado.confirmarSobreescribirPlaza" text="**Confirmacion" />', '<s:message code="plugin.procuradores.turnado.confirmarSobreescribirPlaza" text="**Esta plaza ya dispone de configuración, ¿Estas seguro que desa sobreescribirla?" />', function(seguir){
						if(seguir=='yes'){
							//Borrar todo lo relacioando con la plaza
		       				Ext.Ajax.request({
								url: '/pfs/turnadoprocuradores/borrarConfigParaPlazaOTpoLogico.htm'
								,params: {
											idPlaza: plazaItem.get('id')
											,idEsquema: idEsquema
										}
								,method: 'POST'
								,success: function (result, request){
									var r = Ext.util.JSON.decode(result.responseText);
									//Guardar ids de tuplas y rangos
									for(var i=0; i< r.idTuplas.length; i++){
										idsTuplasBorradasConfig.push(r.idTuplas[i].idTupla);
									}
									for(var i=0; i< r.idsRangos.length; i++){
										idsRangosBorradosConfig.push(r.idsRangos[i].idRango);
									}
									
									//Añadir id al array de id de plazas
									nuevasPlazasConfig.push(plazaItem.get('id'));
									<%-- Llamada que carga el combo de procedimientos en base a si esta la plaza por defecto seleccionada o no (Solo permite añadir tipo procedimiento por defecto de ser así) --%>
									cmbTPO.reset();
									if(plazaItem.get('id')==-1) listadoTPOStore.webflow({plazaDefecto : true});
									else listadoTPOStore.webflow({plazaDefecto : false});
									<%-- Gestion de la disponibilidad del panel de procedimientos --%>
									gestionarPanelNuevoTPO();
									
									//Crear objetos dinamicos
									var campo = new Ext.form.Label({
						  	   				name: 'plaza_'+plazaItem.get('id'),
							   				html:  plazaItem.get('descripcion')+ '&nbsp;',
							   				width:250,
							   				style: 'font-size:12px;'
						   	    	}); 
						   	    	var borrarCampo = new Ext.form.Label({
										   name: 'borrarPlaza_'+plazaItem.get('id'),
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
								  	dimeSiPlazaYaSeleccionada(plazaItem.get('id'));
								  	
								  	//Webflob para cargar el grid
									rangosStore.webflow({idEsquema : idEsquema,  idsPlazas : nuevasPlazasConfig, nuevaConfig : infoConfiguracionTurnado.isVisible()});
								}
								,error: function(result, request){
									Ext.Msg.minWidth=360;
									Ext.Msg.alert("Error","Error borrando");
									mainPanel.container.unmask();
								}
							});
						}
					});
				}
				else {
					//Añadir id al array de id de plazas
					nuevasPlazasConfig.push(plazaItem.get('id'));
					<%-- Llamada que carga el combo de procedimientos en base a si esta la plaza por defecto seleccionada o no (Solo permite añadir tipo procedimiento por defecto de ser así) --%>
					cmbTPO.reset();
					if(plazaItem.get('id')==-1) listadoTPOStore.webflow({plazaDefecto : true});
					else listadoTPOStore.webflow({plazaDefecto : false});
					<%-- Gestion de la disponibilidad del panel de procedimientos --%>
					gestionarPanelNuevoTPO();
					
					//Crear objetos dinamicos
					var campo = new Ext.form.Label({
		  	   				name: 'plaza_'+plazaItem.get('id'),
			   				html:  plazaItem.get('descripcion')+ '&nbsp;',
			   				width:250,
			   				style: 'font-size:12px;'
		   	    	}); 
		   	    	var borrarCampo = new Ext.form.Label({
						   name: 'borrarPlaza_'+plazaItem.get('id'),
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
				  	dimeSiPlazaYaSeleccionada(plazaItem.get('id'));
				  	
				  	//Webflob para cargar el grid
					rangosStore.webflow({idEsquema : idEsquema,  idsPlazas : nuevasPlazasConfig, nuevaConfig : infoConfiguracionTurnado.isVisible()});
				}
			}
			,error: function(result, request){
				Ext.Msg.minWidth=360;
				Ext.Msg.alert("Error","Error comprobando si ya existe configuracion para la plaza seleccionada");
			}
		});
	}
	
	var borrarPlazaConfigEsquema = function(idItem){
		Ext.Ajax.request({
			url: '/pfs/turnadoprocuradores/borrarConfigParaPlazaOTpo.htm'
			,params: {
						idPlaza: idItem
						,idEsquema: idEsquema
					}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//Eliminar id del array de id de plazas
				var index = nuevasPlazasConfig.indexOf(Number(idItem));
				if(index > -1) nuevasPlazasConfig.splice(index, 1);
				
				//Eliminar ids tuplas eliminadas de el array que guarda ids
				for(var i=0; i< r.idTuplas.length; i++){
					var index = idsTuplasConfig.indexOf(r.idTuplas[i].idTupla);
					if(index > -1) idsTuplasConfig.splice(index, 1);
				}
				
				<%-- Llamada que carga el combo de procedimientos en base a si esta la plaza por defecto seleccionada o no (Solo permite añadir tipo procedimiento por defecto de ser así) --%>
				var index = idsTuplasConfig.indexOf(-1);
				if(index > -1) listadoTPOStore.webflow({plazaDefecto : true});
				else listadoTPOStore.webflow({plazaDefecto : false});
				<%-- Gestion de la disponibilidad del panel de procedimientos --%>
				gestionarPanelNuevoTPO();
				
				if(idsTuplasConfig.length>0) btnGuardarNuevaConfiguracion.setDisabled(false);
				else btnGuardarNuevaConfiguracion.setDisabled(true);
				
				//Borrar objetos dinamico
				var cmp = Ext.getCmp('turn_procu_lista_plazas').find('name','plaza_'+idItem)[0];
				cmp.destroy();
				cmp = Ext.getCmp('turn_procu_lista_plazas').find('name','borrarPlaza_'+idItem)[0];
				cmp.destroy();
				dimeSiPlazaYaSeleccionada(idItem);
				
				//Webflob para cargar el grid
				rangosStore.webflow({idEsquema : idEsquema,  idsPlazas : nuevasPlazasConfig, nuevaConfig : infoConfiguracionTurnado.isVisible()});
			}
			,error: function(result, request){
				Ext.Msg.minWidth=360;
				Ext.Msg.alert("Error","Error borrando");
			}
		});
	}
	
	var addNuevoTPOConfigEsquema = function(tpoItem){
		Ext.Ajax.request({
			url: '/pfs/turnadoprocuradores/addNuevoTPOPlazas.htm'
			,params: {
						idTpo: tpoItem.get('id')
						,idEsquema: idEsquema
						,arrayPlazas : nuevasPlazasConfig
					}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//Guardar ids tuplas por si se cancela operacion
				for(var i=0; i< r.idTuplas.length; i++){
					idsTuplasConfig.push(r.idTuplas[i].idTupla);
				}
				
				if(idsTuplasConfig.length>0) btnGuardarNuevaConfiguracion.setDisabled(false);
				else btnGuardarNuevaConfiguracion.setDisabled(true);
				
				//Crear objetos dinamicos
				var campo = new Ext.form.Label({
	  	   				name: 'tpo_'+tpoItem.get('id'),
		   				html:  tpoItem.get('descripcion')+ '&nbsp;',
		   				width:250,
		   				style: 'font-size:12px;'
	   	    	}); 
	   	    	var borrarCampo = new Ext.form.Label({
				   name: 'borrarTpo_'+tpoItem.get('id'),
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
			  	dimeSiTPOYaSeleccionado(tpoItem.get('id'));
			  	gestionarPanelNuevaPlaza();
			  	
			  	//Webflob para cargar el grid
			  	rangosStore.webflow({idEsquema : idEsquema,  idsPlazas : nuevasPlazasConfig, nuevaConfig : infoConfiguracionTurnado.isVisible()});
			}
			,error: function(result, request){
				Ext.Msg.minWidth=360;
				Ext.Msg.alert("Error","Error guardando");
			}
		});
	}
	
	var borrarTPOConfigEsquema = function(tpoValue){
		Ext.Ajax.request({
			url: '/pfs/turnadoprocuradores/borrarConfigParaPlazaOTpo.htm'
			,params: {
						idTpo: tpoValue
						,idEsquema: idEsquema
						,arrayPlazas : nuevasPlazasConfig
					}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//Eliminar ids tuplas eliminadas de el array que guarda ids
				for(var i=0; i< r.idTuplas.length; i++){
					var index = idsTuplasConfig.indexOf(r.idTuplas[i].idTupla);
					if(index > -1) idsTuplasConfig.splice(index, 1);
				}
				
				if(idsTuplasConfig.length>0) btnGuardarNuevaConfiguracion.setDisabled(false);
				else btnGuardarNuevaConfiguracion.setDisabled(true);
				
				//Borrar objetos dinamicos
				var cmp = Ext.getCmp('turn_procu_lista_procedimientos').find('name','tpo_'+tpoValue)[0];
				cmp.destroy();
				cmp = Ext.getCmp('turn_procu_lista_procedimientos').find('name','borrarTpo_'+tpoValue)[0];
				cmp.destroy();
				dimeSiTPOYaSeleccionado(tpoValue);
			  	gestionarPanelNuevaPlaza();
					
				//Webflob para cargar el grid
				rangosStore.webflow({idEsquema : idEsquema,  idsPlazas : nuevasPlazasConfig, nuevaConfig : infoConfiguracionTurnado.isVisible()});
			}
			,error: function(result, request){
				Ext.Msg.minWidth=360;
				Ext.Msg.alert("Error","Error borrando");
			}
		});
	}