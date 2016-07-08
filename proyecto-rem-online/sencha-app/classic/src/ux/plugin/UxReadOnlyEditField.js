/**
 * @class Ux.utils.UxReadOnlyEditField
 * @author Jose Villel
 * 
 * Plugging para los fields de un formulario, que aÃ±ade un componente label junto al input habitual.
 * De esta forma es posible alternar entre ambos en funciÃ³n del modo en el que se abra el formulario.
 * 
 * Se aÃ±aden los eventos y la funcionalidad necesaria para que al lanzarlos se muestre u oculte el componente
 * necesario, y se actualicen los valores.
 * 
 * Se puede utilizar para los componentes TextField, TextArea, Combobox y DateField aÃ±adiendo
 *  plugins: [Ext.create('Ux.utils.UxReadOnlyEditField')]
 * 
 * 
 * BenjamÃ­n: Se ha aÃ±adido una comprobaciÃ³n para mostrar / ocultar ademÃ¡s el triggerWrap para las combobox
 *
 */
Ext.define('HreRem.ux.plugin.UxReadOnlyEditField', {
	
	alias: 'plugin.UxReadOnlyEditField',
	
	/**
	 * Por defecto todos los field serÃ¡n editables, eso significa que al lanzar el evento de ediciÃ³n, se mostrarÃ¡
	 * el input correspondiente. Para que no aparezca el input aun lanzando el evento, es necesario crear el pluggin 
	 * con el atributo editable a false.
	 * @type Boolean
	 */
	editable : true,
	
	clsDisplayLabel : 'label-read-only',
	clsDisplayLabelFormularioCompleto: 'label-read-only-formulario-completo',
	clsDisplayLabelTextarea: 'label-read-only-textarea',

	clsDisplayLabelNoEditable : 'no-editable',
	
	constructor: function(config) {
		
		var me = this,
		config = config || {};
		
		me.editable = Ext.isEmpty(config.editable)? me.editable : config.editable;
		if  (config instanceof  Array) this.callParent(config);		
		
	},
	
	
	init: function(parent){

		this.parent = parent;		
		/**
		 * AÃ±adimos al field este atributo por si queremos buscar todos los fields con el pluggin.
		 */
		this.parent.isReadOnlyEdit = true;
		
		/**	
		 * Dejamos la posibilidad de configurar el plugin para poder guardar en cada modificación del valor de un campo
		 * y no un formulario completo, de manera que al cambiar el valor de un campo lanzaria un evento que podriamos capturar, 
		 * pudiendo guardar en ese momento
		 */
		this.parent.saveSingleField= false,		
		
		this.initEventHandlers();

		
	},
	
	initEventHandlers: function(){
		
		/*
		 * AÃ±adimos los eventos
		 */
		this.parent.on({
			render: this.onParentRender,
			viewonly: this.onViewOnly,
			edit: this.onEdit,
			save: this.onSave,
			cancel: this.onCancel,
			update: this.onUpdate,
			scope: this,
			change: this.onUpdate
		});	

	},

	
	
	/**
	 * FunciÃ³n que una vez renderizado el field aÃ±ade el label y selecciona
	 * el modo de visibilidad de label e input, con la opciÃ³n DISPLAY, para que 
	 * el que estÃ¡ oculto no ocupe espacio.
	 * @param {} field
	 */
	onParentRender: function(field){
		var me = this;
		
		if (field.xtype == 'checkboxfieldbase' || field.xtype == 'radiofieldbase' || this.parent.xtype == 'radiofield') {
			
			field.disabled = true;

		} else {
			
			if (field.xtype == 'textareafieldbase') {
				
				if (!field.saveSingleField) {
				field.displayEl = Ext.DomHelper.append(field.bodyEl, {
					tag: 'div',
					cls: this.clsDisplayLabelTextarea
				}, true).setVisibilityMode(Ext.Element.DISPLAY);
				
				field.displayEl.hide();
				
				} else {
					field.displayEl = Ext.DomHelper.append(field.bodyEl, {
						tag: 'div',
						cls: this.clsDisplayLabel
					}, true).setVisibilityMode(Ext.Element.DISPLAY);
					field.displayEl.hide();
				}

			} else {

				if (!field.saveSingleField) {
					field.displayEl = Ext.DomHelper.append(field.bodyEl, {
						tag: 'div',
						cls: this.clsDisplayLabelFormularioCompleto
					}, true).setVisibilityMode(Ext.Element.DISPLAY);
					
					field.displayEl.hide();
				} else {
					field.displayEl = Ext.DomHelper.append(field.bodyEl, {
						tag: 'div',
						cls: this.clsDisplayLabel
					}, true).setVisibilityMode(Ext.Element.DISPLAY);
					field.displayEl.hide();
				}
			}
				
			/**
			 * La siguiente linea cancela el evento click en los labels para evitar
			 * que los combos se desplieguen donde no toca al recibir el foco. 
			 */
			field.labelEl.on('click', function(e) {e.stopEvent();});
		
			field.inputEl.setVisibilityMode(Ext.Element.DISPLAY);
			field.inputEl.hide();
			
			//field.labelEl.on('click', function() {alert('Entro');});
		
			
			if (field.saveSingleField) {
					field.addListener ({ 
						click: {
			            	element: 'displayEl', //bind to the underlying el property on the panel
			            	fn: function(){ me.onEdit();}
			            }
			      });
			}			
			
			// Por defecto los campos serán viewOnly
			this.onViewOnly();
		}
		
	
	},
	/**
	 * FunciÃ³n que oculta el input y muestra el label actualizando el valor.
	 */
	onViewOnly : function() {
		
		if(this.parent.rendered) {

			if (this.parent.xtype == 'checkboxfieldbase' || this.parent.xtype == 'radiofieldbase' || this.parent.xtype == 'radiofield') {
					this.parent.disabled = true;

		    } else {

	 			this.onUpdate();	 			
	 			this.parent.displayEl.setVisibilityMode(Ext.Element.DISPLAY);
				this.parent.inputEl.setVisibilityMode(Ext.Element.DISPLAY);
				if(!Ext.isEmpty(this.parent.errorEl)) {
					this.parent.errorEl.setVisibilityMode(Ext.Element.DISPLAY);
					this.parent.errorEl.hide();
				}
				
				this.parent.displayEl.show();
				this.parent.inputEl.hide();
				if(this.parent.triggerEl) {
					this.parent.triggerEl.setVisibilityMode(Ext.Element.DISPLAY);
					this.parent.triggerEl.hide();
				}
				if (this.parent.triggerWrap) {
					this.parent.triggerWrap.setVisibilityMode(Ext.Element.DISPLAY);
					this.parent.triggerWrap.hide();
				}
			}
		}
	
	},

	/**
	 * FunciÃ³n que oculta el label y muestra el input, guardandose el valor actual del input, por si cambiara, y se quisiera 
	 * volver al valor anterior.
	 */
	onEdit: function(){

		if(this.parent.rendered ){
			
			if (this.parent.xtype == 'checkboxfieldbase' || this.parent.xtype == 'radiofieldbase' || this.parent.xtype == 'radiofield' || this.parent.xtype == 'radiofield') {
				this.parent.disabled = false;
	
			} else {
				if(this.editable && !this.parent.readOnly) {
					this.parent.displayEl.hide();
					this.parent.displayEl.removeCls(this.clsDisplayLabelNoEditable);
					this.parent.inputEl.show();
					if(!Ext.isEmpty(this.parent.errorEl)) {
						this.parent.errorEl.show();
					}
					if(this.parent.triggerEl && !this.parent.hideTrigger) {
						this.parent.triggerEl.show();
					}
					
					if (this.parent.triggerWrap) {
						this.parent.triggerWrap.show();
					}
					this.parent.cachedValue = this.parent.inputEl.getValue();
					//this.parent.inputEl.focus();
				} else {
					this.onViewOnly();
					this.parent.displayEl.addCls(this.clsDisplayLabelNoEditable);
				}
			}
		}
	},
	
	/**
	 * FunciÃ³n que oculta el input y muestra el label actualizando el valor.
	 */
	onSave: function(){
		
		if (this.parent.xtype == 'checkboxfieldbase' || this.parent.xtype == 'radiofieldbase' || this.parent.xtype == 'radiofield') {
				this.parent.disabled = true;
	
		} else {

			if(this.parent.rendered){

	 			//this.parent.displayEl.update(this.parent.inputEl.getValue());	 	
				this.onUpdate();
				this.parent.displayEl.show();
				this.parent.inputEl.hide();
				if(!Ext.isEmpty(this.parent.errorEl)) {
					this.parent.errorEl.hide();
				}
				if(this.parent.triggerEl) {
					this.parent.triggerEl.hide();
				}
				
				if (this.parent.triggerWrap) {
					this.parent.triggerWrap.hide();
				}
			}
		}
	},

	/**
	 * FunciÃ³n que recupera el valor guardado antes de editar, oculta el input
	 * y muestra el label.
	 */
	onCancel: function(){
		
		if (this.parent.xtype == 'checkboxfieldbase' || this.parent.xtype == 'radiofieldbase' || this.parent.xtype == 'radiofield') {
				this.parent.disabled = true;
	
		} else {

			if(this.parent.rendered){

	 			//this.parent.displayEl.update(this.parent.inputEl.getValue());	 	
				this.onUpdate();
				this.parent.displayEl.show();
				this.parent.inputEl.hide();
				if(!Ext.isEmpty(this.parent.errorEl)) {
					this.parent.errorEl.hide();
				}
				if(this.parent.triggerEl) {
					this.parent.triggerEl.hide();
				}
				
				if (this.parent.triggerWrap) {
					this.parent.triggerWrap.hide();
				}
			}
		}
	},
	/**
	 * FunciÃ³n que actualiza el valor del label con el valor del input.
	 */
	
	onUpdate: function() {

		if(this.parent.rendered){
			
			if(Ext.isEmpty(this.parent.getValue())){
			
				if(!Ext.isEmpty(this.parent.emptyDisplayText)) {
					this.parent.displayEl.update(this.parent.emptyDisplayText);
				} else {
					this.parent.displayEl.update(this.parent.getValue());
				}
			} else {			

				if (this.parent.xtype == 'currencyfieldbase') {
					this.parent.displayEl.update(Ext.util.Format.currency(this.parent.getValue()));	
					
				} else {
					var symbol = Ext.isEmpty(this.parent.symbol) ? "" : " " + this.parent.symbol;
					this.parent.displayEl.update(this.parent.inputEl.getValue() + symbol);	
				}
			}
		}

	}

	
});
