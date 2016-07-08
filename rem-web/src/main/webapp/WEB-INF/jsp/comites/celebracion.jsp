<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:page>

	var comite = app.creaLabel('<s:message code="comite.edicion.comite" text="**Comite"/>',"${dtoSesionComite.comite.nombre}");

	var iniciar = new Ext.Button({
		text : '<s:message code="comite.edicion.iniciarsesion" text="**Iniciar sesi&oacute;n" />'
      ,iconCls:'icon_comite_celebrar'
	  ,handler : function(){
         var params = { asistencias: transform()};
         page.submit({
             flow : 'comites/celebracion'
            ,eventName : 'update'
            ,formPanel : panel
            ,success : 
               function(){ 
                  page.fireEvent(app.event.DONE);
                  app.openTab( "<s:message code="comite.expedientes.tabTitle" text="**Expediente del comité " />"+" "+"${dtoSesionComite.comite.nombre}" 
                               ,'comite/listadoComiteExpedientes'
                               , {idComite : "${dtoSesionComite.comite.id}"}, {id:'ExpComite'+${idComite},iconCls:'icon_comite'});
               }
            ,params: params
         });
       }
	});
   
   function transform(){
      var str = "";
      var data;
      for (var i = 0; i < grid.getStore().getTotalCount(); i++) {         
         data = grid.getStore().getAt(i).data;
         str+= data.id+"="+data.asiste+";";
      }
      return str;
   }

	Ext.grid.CheckColumn = function(config){
	    Ext.apply(this, config);
	    if(!this.id){
	        this.id = Ext.id();
	    }
	    this.renderer = this.renderer.createDelegate(this);
	};
	
	Ext.grid.CheckColumn.prototype ={
	    init : function(grid){
	        this.grid = grid;
	        this.grid.on('render', function(){
	            var view = this.grid.getView();
	            view.mainBody.on('mousedown', this.onMouseDown, this);
	        }, this);
	    },
	
	    onMouseDown : function(e, t){
	        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
	            e.stopEvent();
	            var index = this.grid.getView().findRowIndex(t);
	            var record = this.grid.store.getAt(index);
	            record.set(this.dataIndex, !record.data[this.dataIndex]);
	        }
	    },
	
	    renderer : function(v, p, record){
	        p.css += ' x-grid3-check-col-td'; 
	        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	    }
	};  


	var checkColumn = new Ext.grid.CheckColumn({ 
            header : '<s:message code="comite.edicion.listado.asiste" text="**Asiste" />'
            ,dataIndex : 'asiste'
           <app:test id="checkbox" addComa="true" />
            });

   var Asistente = Ext.data.Record.create([
         {name:'id'}
         ,{name : 'nombre'}
         ,{name : 'apellidos'}
         ,{name : 'restrictivo'}
         ,{name : 'supervisor'}
         ,{name : 'asiste'}
      ]);

   var asistenteStore = page.getStore({
      eventName : 'listadoAsistentes'
      ,flow:'comites/celebracion'
      ,reader: new Ext.data.JsonReader({
        root : 'asistentesJSON'
      } , Asistente)
     });
	
	asistenteStore.webflow();

	
	var cm = new Ext.grid.ColumnModel([
		{header : '<s:message code="comite.edicion.listado.nombre" text="**Nombre"/>', dataIndex : 'nombre'}
		,{header : '<s:message code="comite.edicion.listado.apellido" text="**Apellidos"/>', dataIndex : 'apellidos' }
		,{header : '<s:message code="comite.edicion.listado.restrictivo" text="**Restrictivo"/>', dataIndex : 'restrictivo' }
		,{header : '<s:message code="comite.edicion.listado.supervisor" text="**Supervisor"/>', dataIndex : 'supervisor' }
		,checkColumn
	]);
	
	var grid = new Ext.grid.EditorGridPanel({
		store : asistenteStore
		,title:'<s:message code="comite.edicion.listado.titulo" text="**Asistentes" />'
		,cm : cm
		,clicksToEdit:1
		,iconCls:'icon_usuario'
		 ,width:cm.getTotalWidth()+30
		//,autoWidth:true
		,height : 400
        ,plugins:checkColumn
	});


	var panel = new Ext.form.FormPanel({
	    items : [
			app.creaFieldSet( [comite] )
			,grid
			,iniciar
	    	
	    ]
	    ,bodyStyle: 'padding: 10px'
	    ,border:false
	    ,autoHeight : true
	    ,border: false
	    ,closable:true
        ,autoScroll:true
        <app:test id="iniciarSesionPanel" addComa="true" />
    });
	//añadimos al padre y hacemos el layout
	page.add(panel);
	
</fwk:page>