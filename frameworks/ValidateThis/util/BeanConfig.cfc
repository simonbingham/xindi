<cfcomponent name="LightBaseBeanConfig" extends="BaseConfigObject" hint="A LightWire configuration bean.">
<!--- 
BEAN DEFINITION SYNTAX
SINGLETONS:
addSingleton(FullClassPath, NameList)
Adds the definition for a given Singleton to the config file.
- FullClassPath:string:required - The full class path to the bean including its name. E.g. for com.UserService.cfc it would be com.UserService. 
- BeanName:string:optional - An optional name to be able to use to refer to this bean. If you don't provide this, the name of the bean will be used as a default. E.g. for com.UserService, it'll be named UserService unless you put something else here. If you put UserS, it'd be available as UserS, but NOT as UserService.

addSingletonFromFactory(FactoryBean, FactoryMethod, BeanName)
Adds the definition for a given Singleton that is created by a factory to the config file.
- FactoryBean:string:required - The name of the factory to use to create this bean (the factory must also have been defined as a Singleton in the LightWire config file).
- FactoryMethod:string:required - The name of the method to call on the factory bean to create this bean.
- BeanName:string:required - The required name to use to refer to this bean. 

TRANSIENTS:
addTransient(FullClassPath, NameList)
Adds the definition for a given Transient to the config file.
- FullClassPath:string:required - The full class path to the bean including its name. E.g. for com.UserBean.cfc it would be com.UserBean.
- BeanName:string:optional - An optional name to be able to use to refer to this bean. If you don't provide this, the name of the bean will be used as a default. E.g. for com.UserBean, it'll be named UserService unless you put something else here. If you put User, it'd be available as User, but NOT as UserBean.

addTransientFromFactory(FactoryBean, FactoryMethod, BeanName)
Adds the definition for a given Transient that is created by a factory to the config file.
- FactoryBean:string:required - The name of the factory to use to create this bean (the factory must also have been defined as a Singleton in the LightWire config file).
- FactoryMethod:string:required - The name of the method to call on the factory bean to create this bean.
- BeanName:string:required - The required name to use to refer to this bean. 

BEAN Dependency and PROPERTIES
Once you have defined a given bean, you also want to describe its Dependency and properties. Any bean can have 0..n constructor, setter and/or mixin Dependency and properties. Dependency handle LightWire initialized objects that need to be injected into your beans. Properties handle all other elements (strings, bits, structs, etc.). Please note: constructor Dependency are passed to the init() method, so you need a correspondingly named argument in your init file. Setter Dependency are injected using set#BeanName#() after calling the init() method but before returning the bean, so you need to have the appropriate setter. Mixin injections are auto injected into variables scope for you after calling the init() method but before returning the bean, but you don't need to have a setter() method - it used a generic setter injected automatically into all of your beans (lightwireMixin()).

addConstructorDependency(BeanName, InjectedBeanName, PropertyName)
Adds one or more constructor Dependency to a bean. If you call this more than once on the same bean, the additional Dependency will just be added to the list so it is valid to call this multiple times to build up a dependency list if required.
- BeanName:string:required - The name of the bean (Singleton or Transient) to add the Dependency to. You MUST have defined the bean using addSingleton() AddTransient(), addSingletonFromFactory() or addTransientFromFactory() before you add Dependency to the bean.
- InjectedBeanName:string:required - The name of the bean to inject.
- PropertyName:string:optional - The optional property name to pass the bean into. Defaults to the bean name if not provided.

addSetterDependency(BeanName, InjectedBeanName, PropertyName)
Adds one or more setter Dependency to a bean. If you call this more than once on the same bean, the additional Dependency will just be added to the list so it is valid to call this multiple times to build up a dependency list if required.
- BeanName:string:required - The name of the bean (Singleton or Transient) to add the Dependency to. You MUST have defined the bean using addSingleton() AddTransient(), addSingletonFromFactory() or addTransientFromFactory() before you add Dependency to the bean.
- InjectedBeanName:string:required - The name of the bean to inject.
- PropertyName:string:optional - The optional property name to pass the bean into. Defaults to the bean name if not provided.

addMixinDependency(BeanName, InjectedBeanName, PropertyName)
Adds one or more mixin Dependency to a bean. If you call this more than once on the same bean, the additional Dependency will just be added to the list so it is valid to call this multiple times to build up a dependency list if required.
- BeanName:string:required - The name of the bean (Singleton or Transient) to add the Dependency to. You MUST have defined the bean using addSingleton() AddTransient(), addSingletonFromFactory() or addTransientFromFactory() before you add Dependency to the bean.
- InjectedBeanName:string:required - The name of the bean to inject.
- PropertyName:string:optional - The optional property name to pass the bean into. Defaults to the bean name if not provided.

addConstructorProperty(PropertyName, PropertyValue)
Adds a constructor property to a bean. 
- BeanName:string:required - The name of the bean (Singleton or Transient) to add the property to. You MUST have defined the bean using addSingleton() AddTransient(), addSingletonFromFactory() or addTransientFromFactory() before you add properties to the bean.
- PropertyName:string:required - The name of the property to add.
- PropertyValue:any:required - The value of the property to add. Can be of any simple or complex type (anything from a string or a boolean to a struct or even an object that isn't being managed by LightWire).

addSetterProperty(PropertyName, PropertyValue)
Adds a setter property to a bean. 
- BeanName:string:required - The name of the bean (Singleton or Transient) to add the property to. You MUST have defined the bean using addSingleton() AddTransient(), addSingletonFromFactory() or addTransientFromFactory() before you add properties to the bean.
- PropertyName:string:required - The name of the property to add.
- PropertyValue:any:required - The value of the property to add. Can be of any simple or complex type (anything from a string or a boolean to a struct or even an object that isn't being managed by LightWire).

addMixinProperty(PropertyName, PropertyValue)
Adds a constructor property to a bean. 
- BeanName:string:required - The name of the bean (Singleton or Transient) to add the property to. You MUST have defined the bean using addSingleton() AddTransient(), addSingletonFromFactory() or addTransientFromFactory() before you add properties to the bean.
- PropertyName:string:required - The name of the property to add.
- PropertyValue:any:required - The value of the property to add. Can be of any simple or complex type (anything from a string or a boolean to a struct or even an object that isn't being managed by LightWire).
--->

<cffunction name="init" output="false" returntype="any" hint="I initialize the config bean.">
	<cfargument name="ValidateThisConfig" type="any" required="true" />
	<cfscript>
		// Call the base init() method to set sensible defaults. Do NOT remove this.
		Super.init();
		// OPTIONAL: Set lazy loading: true or false. If true, Singletons will only be created when requested. If false, they will all be created when LightWire is first initialized. Default if you don't set: LazyLoad = true.
		setLazyLoad("false");
		
		variables.ValidateThisConfig = arguments.ValidateThisConfig;
		
		// BEAN DEFINITIONS (see top of bean for instructions)
		addSingleton("ValidateThis.util.LightWire");
		addSingleton("ValidateThis.core.Version");
		addSingleton("ValidateThis.util.ResourceBundle","LoaderHelper");
		addSingleton(variables.ValidateThisConfig.LocaleLoaderPath,"LocaleLoader");
		addSingleton(variables.ValidateThisConfig.TranslatorPath,"Translator");
		addSingleton("ValidateThis.core.RBLocaleLoader","RBLocaleLoader");
		addSingleton("ValidateThis.core.RBTranslator","RBTranslator");
		addSingleton("ValidateThis.util.ObjectChecker");
		addSingleton("ValidateThis.util.FileSystem");
		addSingleton("ValidateThis.util.TransientFactory");
		addSingleton("ValidateThis.core.ChildObjectFactory");
		addSingleton("ValidateThis.core.ExternalFileReader");
		addSingleton("ValidateThis.core.AnnotationReader");
		addSingleton("ValidateThis.server.ServerValidator");
		addSingleton("ValidateThis.client.ClientValidator");
		addSingleton("ValidateThis.client.CommonScriptGenerator");
		addSingleton("ValidateThis.util.EqualsHelper");
		addSingleton("ValidateThis.core.MessageHelper");
		//
		addTransient("ValidateThis.core.Validation");
		addTransient("ValidateThis.core.BusinessObjectWrapper");
		addTransient("ValidateThis.util.ResourceBundle"); //??? do we need this?
		addTransient("ValidateThis.core.fileReaders.FileReader_JSON");
		addTransient("ValidateThis.core.fileReaders.FileReader_XML");
		addTransient(variables.ValidateThisConfig.ResultPath,"Result");
		addTransient("ValidateThis.core.StructWrapper");
		addTransient("ValidateThis.core.annotationTypeReaders.AnnotationTypeReader_JSON");
		addTransient("ValidateThis.core.annotationTypeReaders.AnnotationTypeReader_XML");
		addTransient("ValidateThis.core.annotationTypeReaders.AnnotationTypeReader_VTML");
		addTransient("ValidateThis.core.Parameter");
		/*
		addSingleton("ValidateThis.util.TransientFactoryNoCS");
		addSingleton("ValidateThis.util.FileSystem");
		addSingleton("ValidateThis.core.externalFileReader");
		addSingleton("ValidateThis.server.ServerValidator");
		addSingleton("ValidateThis.client.ClientValidator");
		addSingleton("ValidateThis.client.CommonScriptGenerator");
		*/
		/*
		<cfset variables.Beans.TransientFactory = CreateObject("component","ValidateThis.util.TransientFactoryNoCS").init(variables.Beans.Translator,variables.ValidateThisConfig.ResultPath) />
		<cfset variables.Beans.FileSystem = CreateObject("component","ValidateThis.util.FileSystem").init(variables.Beans.TransientFactory) />
		<cfset variables.Beans.externalFileReader = CreateObject("component","ValidateThis.core.externalFileReader").init(variables.Beans.FileSystem,this,variables.ValidateThisConfig) />
		<cfset variables.Beans.ServerValidator = CreateObject("component","ValidateThis.server.ServerValidator").init(this,variables.Beans.TransientFactory,variables.Beans.ObjectChecker,variables.ValidateThisConfig.ExtraRuleValidatorComponentPaths) />
		<cfset variables.Beans.ClientValidator = CreateObject("component","ValidateThis.client.ClientValidator").init(this,variables.ValidateThisConfig,variables.Beans.Translator,variables.Beans.FileSystem) />
		<cfset variables.Beans.CommonScriptGenerator = CreateObject("component","ValidateThis.client.CommonScriptGenerator").init(variables.Beans.ClientValidator) />
		*/
		// Examples (just delete these once you've got the hang of the API)
		// Product Service
		// addSingleton("lightwire.LightWireTest.com.model.Product.ProductService");
		// addConstructorDependency("ProductService","ProdDAO");
		// addConstructorProperty("ProductService","MyTitle","My Title Goes Here");
		// addSetterProperty("ProductService","MySetterTitle","My Setter Title Goes Here");
		// addMixinProperty("ProductService","MyMixinTitle","My Mixin Title Goes Here");
		// addMixinProperty("ProductService","AnotherMixinProperty","My Other Mixin Property is Here");
		// addMixinDependency("ProductService", "CategoryService");
		// Product DAO
		// addSingleton("lightwire.LightWireTest.com.model.Product.ProductDAO","ProdDAO");		
		// Product
		// addTransient("lightwire.LightWireTest.com.model.Product.ProductBean","Product");
		// addConstructorDependency("Product","ProdDAO");
		// Transfer Factory
		// addSingleton("transfer.TransferFactory");
		// addConstructorProperty("TransferFactory","datasourcePath","/tblog/resources/xml/datasource.xml");
		// addConstructorProperty("TransferFactory","configPath","/tblog/resources/xml/transfer.xml");
		// addConstructorProperty("TransferFactory","definitionPath","/tblog/definitions");
		// Transfer
		// addSingletonFromFactory("TransferFactory","getTransfer","transfer");
		
	</cfscript>
	<cfreturn THIS>
</cffunction>

<cffunction name="addBean" returntype="void" hint="I extend the base addBean Method injecting strings from the VTConfig struct into the constructor." output="false">
	<cfargument name="FullClassPath" required="true" type="string" hint="The full class path to the bean including its name. E.g. for com.UserService.cfc it would be com.UserService.">
	<cfargument name="BeanName" required="false" default="" type="string" hint="An optional name to be able to use to refer to this bean. If you don't provide this, the name of the bean will be used as a default. E.g. for com.UserService, it'll be named UserService unless you put something else here. If you put UserS, it'd be available as UserS, but NOT as UserService.">
	<cfargument name="Singleton" required="true" hint="Whether the bean is a Singleton (1) or Transient(0).">
	<cfargument name="InitMethod" required="false" default="" type="string" hint="A default custom initialization method for LightWire to call on the bean after constructing it fully (including setter and mixin injection) but before returning it.">
	
	<cfscript>
		var md = getComponentMetadata(arguments.FullClassPath);
		var functions = 0;
		var f = 0;
		var params = 0;
		var p = 0;
		var theParam = 0;

		if (len(trim(arguments.BeanName)) eq 0)	{
			arguments.BeanName = listLast(arguments.FullClassPath,".");
		}

		super.addBean(argumentCollection=arguments);
		
		while(structKeyExists(md,"extends")){

			if (structKeyExists(md,"functions")) {
				functions = md.functions;
				for (f = 1; f lte arrayLen(functions); f++)	{
					if (functions[f].name eq "init") {
						params = functions[f].parameters;
						for (p = 1; p lte arrayLen(params); p++) {
							if (params[p].name eq "ValidateThisConfig")	{
								addConstructorProperty(BeanName,"ValidateThisConfig",variables.ValidateThisConfig);
							} else {
								if (params[p].type eq "any" and params[p].name neq "theObject") {
									addConstructorDependency(BeanName,params[p].name);
								} else {
									if (structKeyExists(variables.ValidateThisConfig,params[p].name)) {
										addConstructorProperty(BeanName,params[p].name,variables.ValidateThisConfig[params[p].name]);
									}
								}
							}
							
						}
						return;
					}
				}
			}
			//to climb the tree
			md = md.extends;
		}
		
	</cfscript>
	
	
</cffunction>


</cfcomponent>