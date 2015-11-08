var solution = new Solution('Empty');
var project = new Project('Empty');
project.setDebugDir('build/windows');
project.addSubProject(Solution.createProject('build/windows-build'));
project.addSubProject(Solution.createProject('C:/HaxeToolkit/haxe/lib/kha/15,10,0'));
project.addSubProject(Solution.createProject('C:/HaxeToolkit/haxe/lib/kha/15,10,0/Kore'));
solution.addProject(project);
return solution;
