	<%-- Botones filtros --%>
	var btnBorrarPlaza = new Ext.Button({
			text : '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,handler : function(){
				//flagTest3 = true;
				//rangosGrid.toggleCollapse(flagTest3);		
			}
	});
	
	var btnBorrarTPO = new Ext.Button({
			text : '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,handler : function(){
				//flagTest3 = true;
				//rangosGrid.toggleCollapse(flagTest3);		
			}
	});
	
	<%-- Grid plazas --%>
	var plaza = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'descripcion'}
	]);	
	
	var plazasStore = page.getStore({
		 flow: 'turnadoprocuradores/getPlazasGrid'
		,remoteSort: true
		,autoLoad: false
		,reader : new Ext.data.JsonReader({
	            root:'plazasEsquema'
	        }, plaza)
	});	
	
	var plazasCm = new Ext.grid.ColumnModel([	    
		{header: 'Id', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.config.rangoturnado.buscador.grid.descripcion" text="**Nombre"/>', dataIndex: 'descripcion', sortable: true}
	]);
	
	var smPlaza = new Ext.grid.RowSelectionModel({
		checkOnly : false
		,singleSelect: true
        ,listeners: {
            rowselect: function(p, rowIndex, r) {
            	if(rangosGrid.getSelectionModel().hasSelection()) rangosGrid.getSelectionModel().clearSelections();
            	if(tposGrid.getSelectionModel().hasSelection()) tposGrid.getSelectionModel().clearSelections();
            	if (!this.hasSelection()) {
            		return;
            	}
            	var idPlaza = r.data.id;
            	tposStore.webflow({idEsquema : idEsquema,  idPlaza : idPlaza});
            	rangosStore.webflow({idEsquema : idEsquema,  idPlaza : idPlaza, idTPO : ''});
				//btnBorrar.setDisabled(!borrable);
			
            }
         }
	});
	
	var plazasGrid = new Ext.grid.EditorGridPanel({
		store: plazasStore
		,cm: plazasCm
		,title:'<s:message code="" text="**Plazas"/>'
		,stripeRows: true
		,height:150
		,resizable:false
		,titleCollapse : true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding-bottom:10px; padding-right:10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: smPlaza
		,bbar : [btnBorrarPlaza]
	});
	
	<%-- Grid procedimientos --%>
	var tpo = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'descripcion'}
	]);				
	
	var tposStore = page.getStore({
		 flow: 'turnadoprocuradores/getTPOsGrid'
		,remoteSort: true
		,reader: new Ext.data.JsonReader({
	    	 root : 'tipoProcedimientos'
	     }, tpo)
	});	
	
	var tposCm = new Ext.grid.ColumnModel([	    
		{header: 'Id', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.config.rangoturnado.buscador.grid.descripcion" text="**Nombre"/>', dataIndex: 'descripcion', sortable: true}
	]);
	
	var smTpo = new Ext.grid.RowSelectionModel({
		checkOnly : false
		,singleSelect: true
        ,listeners: {
            rowselect: function(p, rowIndex, r) {
            	if(rangosGrid.getSelectionModel().hasSelection()) rangosGrid.getSelectionModel().clearSelections();
            	if (!this.hasSelection()) {
            		return;
            	}
            	var idTPO = r.data.id;
            	if(plazasGrid.getSelectionModel().getSelected()!=null){
            		var idPlaza = plazasGrid.getSelectionModel().getSelected().data.id;
            		rangosStore.webflow({idEsquema : idEsquema,  idPlaza : idPlaza, idTPO : idTPO});
            	}
				//btnBorrar.setDisabled(!borrable);
			
            }
         }
	});
	
	var tposGrid = new Ext.grid.EditorGridPanel({
		store: tposStore
		,cm: tposCm
		,title:'<s:message code="" text="**Tipos procedimientos"/>'
		,stripeRows: true
		,height:150
		,resizable:false
		,titleCollapse : true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,hidden: true
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding-bottom:10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: smTpo
		,bbar : [btnBorrarTPO]
	});
	
	<%-- Panel filtros --%>
	var turnadoFiltrosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelLitigios.titulo**" text="**Seleccion plazas y procedimientos" />'
		,layout:'table'
		,autoHeight:true
		,border:true
		,hidden:false
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,collapsible : true
		,collapsed : false
		,viewConfig : { columns : 2 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:400 }
		,items : [
		 	{items:[plazasGrid]},
		 	{items:[tposGrid]}
		]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(900-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	plazasStore.webflow({ idEsquema : idEsquema });
	