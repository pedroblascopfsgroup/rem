/**
 * @class Ux.utils.UxReadOnlyEditField
 * @author Jose Villel
 * 
 * Plugging para los fields de un formulario, que anyade un componente label junto al input habitual.
 * De esta forma es posible alternar entre ambos en funcion del modo en el que se abra el formulario.
 * 
 * Se aÃ±aden los eventos y la funcionalidad necesaria para que al lanzarlos se muestre u oculte el componente
 * necesario, y se actualicen los valores.
 * 
 * Se puede utilizar para los componentes TextField, TextArea, Combobox y DateField anyadiendo
 *  plugins: [Ext.create('Ux.utils.UxReadOnlyEditField')]
 * 
 * 
 * BenjamÃ­n: Se ha anyadido una comprobacion para mostrar / ocultar ademas el triggerWrap para las combobox
 *
 */
Ext.define('HreRem.ux.plugin.UxReadOnlyEditField', {
	
	alias: 'plugin.UxReadOnlyEditField',
	
	/**
	 * Por defecto todos los field seran editables, eso significa que al lanzar el evento de edicion, se mostrara
	 * el input correspondiente. Para que no aparezca el input aun lanzando el evento, es necesario crear el pluggin 
	 * con el atributo editable a false.
	 * @type Boolean
	 */
	editable : true,
	
	clsDisplayLabel : 'label-read-only',
	clsDisplayLabelFormularioCompleto: 'label-read-only-formulario-completo',
	clsDisplayLabelTextarea: 'label-read-only-textarea',
	clsDisplayLabelItemSelector: 'item-selector-form-read-only',
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
		 * Anyadimos al field este atributo por si queremos buscar todos los fields con el pluggin.
		 */
		this.parent.isReadOnlyEdit = true;
		
		/**	
		 * Dejamos la posibilidad de configurar el plugin para poder guardar en cada modificacion del valor de un campo
		 * y no un formulario completo, de manera que al cambiar el valor de un campo lanzaria un evento que podriamos capturar, 
		 * pudiendo guardar en ese momento
		 */
		this.parent.saveSingleField= false,		
		
		this.initEventHandlers();

		
	},
	
	initEventHandlers: function(){
		
		/*
		 * Anyadimos los eventos
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
	 * Funcion que una vez renderizado el field anyade el label y selecciona
	 * el modo de visibilidad de label e input, con la opciÃ³n DISPLAY, para que 
	 * el que esta oculto no ocupe espacio.
	 * @param {} field
	 */
	onParentRender: function(field){
		var me = this;
		
		if (field.xtype == 'checkboxfieldbase' || field.xtype == 'radiofieldbase' || this.parent.xtype == 'radiofield') {
			
			field.disabled = true;

		} else if (this.parent.xtype == 'itemselectorbase') {

			field.titleDisplayEl = Ext.DomHelper.append(field.bodyEl, {
				tag: 'div',
				html: '<div class="x-panel-header x-header x-unselectable x-panel-header-default x-horizontal x-panel-header-horizontal x-panel-header-default-horizontal x-top x-panel-header-top x-panel-header-default-top x-docked-top x-panel-header-docked-top x-panel-header-default-docked-top x-box-layout-ct x-panel-default-outer-border-trl" role="presentation" style="right: auto; left: 0px; top: 0px; width: 174px;"><div data-ref="innerCt" role="presentation" class="x-box-inner" style="width: 154px; height: 20px;"><div data-ref="targetEl" class="x-box-target" role="presentation" style="width: 154px;"><div class="x-title x-panel-header-title x-panel-header-title-default x-box-item x-title-default x-title-rotate-none x-title-align-left" role="presentation" unselectable="on"  style="right: auto; top: 0px; margin: 0px; left: 0px; width: 154px;"><div data-ref="textEl" class="x-title-text x-title-text-default x-title-item" unselectable="on" role="presentation">' + field.toTitle + '</div></div></div></div></div>'
			}, true).setVisibilityMode(Ext.Element.DISPLAY);
			
			field.displayEl = Ext.DomHelper.append(field.bodyEl, {
				tag: 'div',
				cls: this.clsDisplayLabelTextarea + ' ' + this.clsDisplayLabelItemSelector
			}, true).setVisibilityMode(Ext.Element.DISPLAY);
			
			field.displayEl.hide();
			field.titleDisplayEl.hide();
			
			// Por defecto los campos serán viewOnly
			this.onViewOnly();
			
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
	 * Funcion que oculta el input y muestra el label actualizando el valor.
	 */
	onViewOnly : function() {
		
		if(this.parent.rendered) {

			if (this.parent.xtype == 'checkboxfieldbase' || this.parent.xtype == 'radiofieldbase' || this.parent.xtype == 'radiofield') {
					this.parent.disabled = true;

			} else if (this.parent.xtype == 'itemselectorbase') {
				this.onUpdate();	 			
	 			this.parent.displayEl.setVisibilityMode(Ext.Element.DISPLAY);
	 			this.parent.titleDisplayEl.setVisibilityMode(Ext.Element.DISPLAY);
				this.parent.ariaEl.component.containerEl.setVisibilityMode(Ext.Element.DISPLAY);
				if(!Ext.isEmpty(this.parent.errorEl)) {
					this.parent.errorEl.setVisibilityMode(Ext.Element.DISPLAY);
					this.parent.errorEl.hide();
				}
				
				//this.parent.titleDisplayEl.show(); // Comentado para ocultar la cabecera en readOnly.
				this.parent.displayEl.show();
				this.parent.ariaEl.component.containerEl.hide();
				
				if(this.parent.triggerEl) {
					this.parent.triggerEl.setVisibilityMode(Ext.Element.DISPLAY);
					this.parent.triggerEl.hide();
				}
				if (this.parent.triggerWrap) {
					this.parent.triggerWrap.setVisibilityMode(Ext.Element.DISPLAY);
					this.parent.triggerWrap.hide();
				}
			
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
	 * Funcion que oculta el label y muestra el input, guardandose el valor actual del input, por si cambiara, y se quisiera 
	 * volver al valor anterior.
	 */
	onEdit: function(){

		if(this.parent.rendered ){
			
			if (this.parent.xtype == 'checkboxfieldbase' || this.parent.xtype == 'radiofieldbase' || this.parent.xtype == 'radiofield') {
				this.parent.disabled = false;
				
			} else if (this.parent.xtype == 'itemselectorbase') {

				if(this.editable && !this.parent.readOnly) {
					this.parent.titleDisplayEl.hide();
					this.parent.titleDisplayEl.removeCls(this.clsDisplayLabelNoEditable);
					this.parent.displayEl.hide();
					this.parent.displayEl.removeCls(this.clsDisplayLabelNoEditable);
					this.parent.ariaEl.component.containerEl.show();
					if(!Ext.isEmpty(this.parent.errorEl)) {
						this.parent.errorEl.show();
					}
					if(this.parent.triggerEl && !this.parent.hideTrigger) {
						this.parent.triggerEl.show();
					}
					
					if (this.parent.triggerWrap) {
						this.parent.triggerWrap.show();
					}
					this.parent.cachedValue = this.parent.getValue();
				}
				
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
				} else {
					this.onViewOnly();
					this.parent.displayEl.addCls(this.clsDisplayLabelNoEditable);
				}
			}
		}
	},
	
	/**
	 * Funcion que oculta el input y muestra el label actualizando el valor.
	 */
	onSave: function(){
		
		if (this.parent.xtype == 'checkboxfieldbase' || this.parent.xtype == 'radiofieldbase' || this.parent.xtype == 'radiofield') {
				this.parent.disabled = true;
	
		
		} else if (this.parent.xtype == 'itemselectorbase') {
			
			if(this.parent.rendered){
	
				this.onUpdate();
				//this.parent.titleDisplayEl.show(); // Comentado para ocultar la cabecera en readOnly.
				this.parent.displayEl.show();
				this.parent.ariaEl.component.containerEl.hide();
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
			

		} else {

			if(this.parent.rendered){
 	
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
	 * Funcion que recupera el valor guardado antes de editar, oculta el input
	 * y muestra el label.
	 */
	onCancel: function(){
		if (this.parent.xtype == 'checkboxfieldbase' || this.parent.xtype == 'radiofieldbase' || this.parent.xtype == 'radiofield') {
				this.parent.disabled = true;
	
				
		} else if (this.parent.xtype == 'itemselectorbase') {

			if(this.parent.rendered){
	
				this.onUpdate();
				//this.parent.titleDisplayEl.show(); // Comentado para ocultar la cabecera en readOnly.
				this.parent.displayEl.show();
				this.parent.ariaEl.component.containerEl.hide();
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

		} else {

			if(this.parent.rendered){
 	
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
	 * Funcion que actualiza el valor del label con el valor del input.
	 */
	
	onUpdate: function() {
		var me = this;
		
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
					
				}else if (this.parent.xtype == 'itemselectorbase') {
					var results = this.parent.getValue();
					var stringResults = '';
					Ext.Array.each(results, function(n) {
						if (n != 'VALOR_POR_DEFECTO'){
							if (me.parent.getStore().findRecord('codigo', n) != null)
								stringResults = stringResults + me.parent.getStore().findRecord('codigo', n).getData().descripcion + '<br>';
						}
			        });
					
					this.parent.displayEl.update(stringResults);
					
				} else {
					var symbol = Ext.isEmpty(this.parent.symbol) ? "" : " " + this.parent.symbol;
					this.parent.displayEl.update(this.parent.inputEl.getValue() + symbol);	
				}
			}
		}

	}

	
});
