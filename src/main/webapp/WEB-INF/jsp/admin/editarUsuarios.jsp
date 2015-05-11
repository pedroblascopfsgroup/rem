<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:page>
Ext.log("page1="+page);
var Usuario = Ext.data.Record.create([
	{name : 'nombre'}
	,{name : 'email'}
	,{name : 'password'}
	,{name : 'username'}
	,{name : 'apellido1'}
	,{name : 'apellido2'}
]);

var usersStore = page.getStore({
	limit : 7
	,eventName : 'getData'
	,reader: new Ext.data.JsonReader({
    	root : 'users'
    	,totalProperty : 'total'
    }, Usuario)
});



var filtro = new Ext.form.TextField({
	enableKeyEvents : true
	,listeners : {
			keypress : function(target, e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					usersStore.refrescar();
  					}
  				}
	}
});


usersStore.refrescar = function(){
		usersStore.webflow({criterio:filtro.getValue(), start:0});
};



//llamamos manualmente al método de recarga al inicio de esta página
usersStore.webflow();

var openWindow = function(url, params){
	var w = new Ext.Window({
		title : 'Datos de usuario'
		,width : 600
		,height : 400
		,autoShow : true
		,autoHeight : true
		,modal : true
	});
	w.show();
	w.load({
			url : url
			,scripts : true
			,params : params || {}
			,scope : w
		});
	w.on('done', function(){ 
		usersStore.refrescar();
		w.close();
	});
}

var campo = new Ext.Toolbar.MenuButton({
	text : 'campo'
	,tooltip : 'Campo por el que filtrar'
	,menu : {items:[
		new Ext.menu.CheckItem({text : 'Nombre', value : 'nombre', checked : true})
		,new Ext.menu.CheckItem({text : 'Apellidos', value : 'apellido1', checked : false})
		,new Ext.menu.CheckItem({text : 'Login', value : 'username', checked : false})
		]
	}
});


var buscar = new Ext.Button({
	text : 'buscar'
	,handler : usersStore.refrescar
});



var nuevo = new Ext.Button({
	text : '<s:message code="admin.users.add" text="Nuevo" />'
	,handler : function(){
		openWindow('/pfs/admin/editUsuario.htm');
	}
});

var borrar = new Ext.Button({
	text : '<s:message code="admin.users.borrar" text="**Borrar" />'
	,handler : function(){
		Ext.Msg.confirm(fwk.constant.confirmar,'<s:message code="" text="**¿Seguro que desea borrar?" />',this.decide, this);
	}
	,decide : function(boton){
		if (boton=='yes'){
			this.borrar();
		}
	}
	,borrar : function(){
		var rec = grid.getSelectionModel().getSelected();
		page.webflow({
			flow : 'admin/borrarUsuario'
			,params : {id : rec.get('username')}
			,success : function(response, config){
				usersStore.refrescar();	
			}
		});
	}
});


var borrarToken;

var borrar2 = new Ext.Button({
	text : 'borrar2'
	,qtip : 'borrar con confirmación del servidor'
	,handler : function(){
		var rec = grid.getSelectionModel().getSelected();
		borrarToken = page.webflow({
			flow : 'admin/borrarUsuario2'
			,params : {id : rec.get('username')}
			,success : function(response, config){
				Ext.Msg.prompt("Confirmación", "escriba un valor>10 para borrar", this.comprobar, this);	
			}
			,scope:this
		});
	}
	,comprobar : function(boton, value){
		if (parseInt(value)<10){
			fwk.alert("Ese valor no es válido, abortando el borrado");
		}else{
			//aquí volvemos a enviar al flow para borrar de verdad
			borrarToken.webflow({
				eventName : 'delete'
				,success : usersStore.refrescar
			});
		}
	}
	
});

//callback cuando hemos guardado ok
var datosGuardadosOK= function(data){
	Ext.log("datosGuardadosOK");
	grid.modifiedData={};//reiniciamos los datos modificados
	usersStore.webflow();
};

var guardar = new Ext.Button({
	text : '**Guardar'
	,handler : function(){
		//Ext.Msg.confirm(fwk.msg.confirmar,'<s:message code="" text="**¿Seguro que desea guardar?" />',this.decide, this);
		this.guardar();
		}
	,decide : function(boton){
			if (boton=='yes'){
				this.guardar();
			}
		}
	,guardar : function(){
			page.webflow({
				flow : 'admin/editarUsuarios'
				,eventName : 'update'
				,success : datosGuardadosOK
				,params : grid.modifiedData
			});
		}
	});

var sm = new Ext.grid.CheckboxSelectionModel();
var grid = new Ext.grid.EditorGridPanel({
	title : 'Usuarios'
	,cm : new Ext.grid.ColumnModel([sm,
		{header : 'Login', dataIndex : 'username', sortable : true }
		,{header : 'Password', dataIndex : 'password'}
		,{header : 'Nombre', dataIndex : 'nombre', editor : new Ext.form.TextField({
			allowBlank : false
			})}
		,{header : 'Apellido1', dataIndex : 'apellido1', editor : new Ext.form.TextField({
			allowBlank : false
			})}
		,{header : 'Apellido2', dataIndex : 'apellido2'}
	])
	,store: usersStore
	,autoHeight : true
	,viewConfig : {
		autoFill : true
		,forceFit : true
	}
	,tbar :[
		campo
		,filtro
		,buscar
		,'-'
		,nuevo
		,borrar
		,borrar2
		,guardar
		
	]
	,selModel: sm
	,clicksToEdit:1
	,bbar : [  fwk.ux.getPaging(usersStore)  ]
});

grid.modifiedData = {};

//TODO : encapsular esta funcionalidad en un control derivado (?) merece la pena?
//almacena los cambios editados en el grid para luego enviarlos
//le ponemos usuarios porque el array de objetos del formulario en el servidor se accede mediante la propiedad usuarios
grid.on('afteredit', function(editEvent){
	grid.modifiedData['usuarios['+editEvent.row+'].'+editEvent.field]=editEvent.value;
});

grid.on('rowdblclick', function(grid, rowIndex, e){
	
	var rec = usersStore.getAt(rowIndex);
	openWindow('/pfs/admin/editUsuario.htm',{id : rec.get('username')});
	
	
});

//añadimos al padre y hacemos el layout
page.add(grid);
	
</fwk:page>