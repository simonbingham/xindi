<!--- 
LICENSE 
Copyright 2008 Brian Kotek

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

File Name: 

	TDOBeanInjectorObserver.cfc (Transfer Decorator Object Bean Injector Observer)
	
Version: 1.1	

Description: 

	This is a Transfer Observer that will autowire your Transfer Decorators with matching beans from
	ColdSpring when the Decorator is created. This makes it much easier to create "rich" Decorators that can handle
	much more business logic than standard Transfer Objects. The dependencies are cached by composed BeanInjector component 
	for performance. After the first instance of a Decorator is created, all subsequent Decorators of that type will have their 
	dependencies injected using cached information. The component is thread-safe. It relies in the composed BeanInjector
	component to perform the autowiring of the Decorator. For full details on the BeanInjector, please see the comments
	at the top of that component.

Usage:

	Usage of the Observer is fairly straightforward. The ColdSpring XML file might look like this:
	
		<bean id="transferFactory" class="transfer.transferFactory">
		   <constructor-arg name="datasourcePath"><value>/project/config/datasource.xml</value></constructor-arg>
		   <constructor-arg name="configPath"><value>/project/config/transfer.xml</value></constructor-arg>
		   <constructor-arg name="definitionPath"><value>/project/transfer/definitions</value></constructor-arg>
		</bean>
		
		<bean id="transfer" factory-bean="transferFactory" factory-method="getTransfer" />
		
		<bean id="TDOBeanInjectorObserver" class="project.components.TDOBeanInjectorObserver" lazy-init="false">
			<constructor-arg name="transfer">
				<ref bean="transfer" />
			</constructor-arg>
			<property name="beanInjector">
				<ref bean="beanInjector" />
			</property>
		</bean>
		
		<bean id="beanInjector" class="project.components.BeanInjector" />
		
		<bean id="validatorFactory" class="components.ValidatorFactory" />
	
	Your ColdSpring configuration must be set to inject the Transfer object into the Observer as a constructor argument.
	It must also be set to inject the BeanInjector as a property. The Observer will register itself with Transfer using the 
	transfer.addAfterNewObserver() method. To ensure that this happens at application startup, you have two options:
	
	1. Use the latest version of ColdSpring that supports lazy-init. What this means is that ColdSpring will automatically
	construct all beans that have lazy-init="false" defined in the ColdSpring XML (as the TDOBeanInjectorObserver bean is in
	the above config snippet). You tell ColdSpring to construct all non-lazy beans when you create the BeanFactory:
	
		<cfset beanFactory.loadBeans(beanDefinitionFile=configFileLocation, constructNonLazyBeans=true) />
	
	Using this approach, the TDOBeanInjectorObserver will be registerd with Transfer without you have to do anything else.
	
	2. On older versions of ColdSpring, or if you do not wish to use the lazy-init capability, the only additional step
	required is to create an instance of the Observer after you initialize ColdSpring, like this:
	
		<cfset beanFactory.loadBeans(beanDefinitionFile=configFileLocation) />
		<cfset beanFactory.getBean('TDOBeanInjectorObserver') />
		
	This ensures that the Observer is constructed and registers itself with Transfer.
	
	Your Transfer Decorator would have public setter method(s) for the bean(s) you want to inject, for example:
	
		<cffunction name="setValidatorFactory" access="public" returntype="void" output="false" hint="I set the ValidatorFactory.">
			<cfargument name="validatorFactory" type="any" required="true" hint="ValidatorFactory" />
			<cfset variables.instance.validatorFactory = arguments.validatorFactory />
		</cffunction>
	
	Once the Observer is registered with Transfer, any time you create a Transfer Decorator, the Observer will
	automatically inject any dependent beans into it at creation time. So in the above example, as soon as the
	Decorator is created, it will automatically have the ValidatorFactory injected into it via the setValidatorFactory()
	method. The end result is that any setters in your Decorators that have matching bean IDs in ColdSpring will have those 
	beans injected automatically. As an additional example, a bean with an ID of "productService" would be autowired
	into a Decorator that had a public setter method named setProductService(), and so on.
	
	There is an optional constructor argument called "afterCreateMethod", which is the name of a method to execute
	on the Decorator after the dependent beans have been injected. If this method exists on your Decorator, it will be called
	immediately after the beans are injected. This allows you to have some setup or initialization code that has access
	to all of the dependent beans. This is needed because Transfer allows you to define a method called "configure" in your
	Decorator which it will run after the Decorator is created. However, configure() runs BEFORE the Observer is called, so
	configure() can't use any of the beans that will be injected by this Observer. Defining an afterCreateMethod will allow you
	to get around this problem. For example, if you define an afterCreateMethod constructor argument to this Observer in your 
	ColdSpring configuration file with a value of "setup", this observer will look for a method called setup() in your Decorators and 
	execute that method if it exists, immediately after the beans have been injected.
	
	There are also some useful options that can be specified on the BeanInjector component itself. Please see the comments
	in the BeanInjector component for a full description of their usage.
	
--->

<cfcomponent name="TDOBeanInjectorObserver" hint="">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfargument name="transfer" type="transfer.com.Transfer" required="true" />
		<cfargument name="afterCreateMethod" type="string" required="false" default="" />
		<cfset variables.afterCreateMethod = arguments.afterCreateMethod />
		<cfset arguments.transfer.addAfterNewObserver(this) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="actionAfterNewTransferEvent" hint="Do something on the new object" access="public" returntype="void" output="false">
	    <cfargument name="event" hint="" type="transfer.com.events.TransferEvent" required="Yes">
		<cfset getBeanInjector().autowire(targetComponent=arguments.event.getTransferObject(), 
										  targetComponentTypeName=arguments.event.getTransferObject().getClassName(), 
										  stopRecursionAt='transfer.com.TransferDecorator') />
		<cfif Len(variables.afterCreateMethod) and StructKeyExists(arguments.event.getTransferObject(), variables.afterCreateMethod)>
			<cfinvoke component="#arguments.event.getTransferObject()#" method="#variables.afterCreateMethod#" />
		</cfif>
	</cffunction>
	
	<cffunction name="getBeanInjector" access="public" returntype="any" output="false" hint="I return the BeanInjector.">
		<cfreturn variables.instance.beanInjector />
	</cffunction>
		
	<cffunction name="setBeanInjector" access="public" returntype="void" output="false" hint="I set the BeanInjector.">
		<cfargument name="beanInjector" type="any" required="true" hint="BeanInjector" />
		<cfset variables.instance.beanInjector = arguments.beanInjector />
	</cffunction>

</cfcomponent>