import java.util.*;
import ast.Program;
import natlab.*;
import analysis.*;
import ast.*;
import nodecases.*;
import com.google.common.base.Joiner;

// Reaching defs:
// Six steps:
// (1) A definition is an assignment of a value to a variable
// (2) Define domain: sets of assignments
// (3) Forward or backward?: forward
// (4) Dataflow equations: out = (in - kill) + gen
// d: x = E
// kill(d) = previous definitions of x
// gen(d) = {d}
// (5) Merge?
// set union
// (6) Initial and approximation for others
// out(entry) = {}
// out(Si) = {}  

public class ReachingDefs extends ForwardAnalysis<Set<AssignStmt>> { // (2) and (3)
  public ReachingDefs(ASTNode tree) {
    super(tree);
  }

  // (6)
  @Override public Set<AssignStmt> newInitialFlow() {
    return new HashSet<>();
  }

  @Override public Set<AssignStmt> copy(Set<AssignStmt> src) {
    return new HashSet<>(src);  
  }

  // (5)
  @Override public Set<AssignStmt> merge(Set<AssignStmt> in1, Set<AssignStmt> in2) {
    Set<AssignStmt> out = new HashSet<>(in1);
    out.addAll(in2);
    return out;
  }

  @Override public void caseStmt(Stmt node) {
    // superclass variables:
    // currentInSet: A
    // currentOutSet: A
    // inFlowSets: Map<ASTNode, A>
    // outFlowSets: Map<ASTNode, A>
    inFlowSets.put(node, copy(currentInSet));
    currentOutSet = copy(currentInSet);
    outFlowSets.put(node, copy(currentOutSet));
  }

  // (4)
  @Override public void caseAssignStmt(AssignStmt node) {
    inFlowSets.put(node, copy(currentInSet));
    
    // out = in
    currentOutSet = copy(currentInSet);
    // out = out - kill
    currentOutSet.removeAll(kill(node));
    // out = out + gen
    currentOutSet.addAll(gen(node));

    outFlowSets.put(node, copy(currentOutSet));
  }

  private Set<AssignStmt> kill(AssignStmt node) {
    Set<AssignStmt> r = new HashSet<>();
    Set<String> namesToKill = node.getLValues();
    for (AssignStmt def : currentInSet) {
      Set<String> names = def.getLValues();
      names.retainAll(namesToKill);
      if (!names.isEmpty()) {
        r.add(def);
      }
    }
    return r;
  }

  private Set<AssignStmt> gen(AssignStmt node) {
    Set<AssignStmt> s = new HashSet<>();
    s.add(node);
    return s;
  }

  public static void main(String[] args) {
    Program ast = parseOrDie(args[0]);
    ReachingDefs analysis = new ReachingDefs(ast);
    analysis.analyze();
    printWithAnalysisResults(ast, analysis);
  }

  private static Program parseOrDie(String path) {
    java.util.List<CompilationProblem> errors = new ArrayList<>();
    Program ast = Parse.parseMatlabFile(path, errors);
    if (!errors.isEmpty()) {
      System.err.println("Parse error: " + Joiner.on('\n').join(errors));
      System.exit(1);
    }
    return ast;
  }

  private static void printWithAnalysisResults(final Program ast, final ReachingDefs analysis) {
    class Printer extends AbstractNodeCaseHandler {
      @Override public void caseASTNode(ASTNode node) {
        for (int i = 0; i < node.getNumChild(); ++i) {
          node.getChild(i).analyze(this);
        }
      }

      @Override public void caseStmt(Stmt node) {
        caseASTNode(node);
        
        System.out.println("========");
        System.out.println("in set:");
        System.out.println("");
        printSet(analysis.getInFlowSets().get(node));

        System.out.println("--------");
        System.out.printf("stmt covering line(s) %s to %s:\n", node.getStartLine(), node.getEndLine());  
        System.out.println("");
        System.out.println(node.getPrettyPrinted());

        System.out.println("--------");
        System.out.println("out set:");
        System.out.println("");
        printSet(analysis.getOutFlowSets().get(node));
        System.out.println("========");
      }

      private void printSet(Set<AssignStmt> defs) {
        for (AssignStmt def : defs) {
          System.out.printf("%s at [%s, %s]\n", ((NameExpr)def.getLHS()).getName().getID(), def.getStartLine(), def.getStartColumn());
        }
      }
    }
    ast.analyze(new Printer());
  }
}
