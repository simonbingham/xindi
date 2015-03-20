component extends = "testbox.system.BaseSpec" {

	variables.mockbox = new testbox.system.MockBox();

	function setup(required cfcPath) {
		variables.CUT = createobject("component", arguments.cfcPath);
		variables.mockbox.prepareMock(variables.CUT);
	}

}
