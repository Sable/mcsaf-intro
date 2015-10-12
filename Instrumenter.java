import java.util.*;
import ast.*;
import natlab.*;
import nodecases.*;
import com.google.common.base.Joiner;

public class Instrumenter extends AbstractNodeCaseHandler {
  public static void main(String[] args) {
    // Parse the contents of args[0]
    // (If it doesn't parse, abort)
    Program ast = parseOrDie(args[0]);
    ast.analyze(new Instrumenter());
    System.out.println(ast.getPrettyPrinted());
  }

  private Set<AssignStmt> skip = new HashSet<>();

  @Override public void caseASTNode(ASTNode node) {
    for (int i = 0; i < node.getNumChild(); ++i) {
      node.getChild(i).analyze(this);
    }
  }

  @Override public void caseFunction(Function node) {
    insertCounterDeclaration(node);
    caseASTNode(node);
  }

  @Override public void caseForStmt(ForStmt node) {
    insertIncrementAtStart(node);
    skip.add(node.getAssignStmt());
    caseASTNode(node);
  }

  @Override public void caseAssignStmt(AssignStmt node) {
    if (skip.contains(node)) {
      return;
    }
    insertIncrementAfter(node);
  }

  private void insertCounterDeclaration(Function node) {
    node.getStmts().insertChild(makeDeclaration(), 0);
  }

  private void insertIncrementAtStart(ForStmt node) {
    node.getStmts().insertChild(makeIncrement(), 0);
  }

  private void insertIncrementAfter(AssignStmt node) {
    ASTNode parent = node.getParent();
    int index = parent.getIndexOfChild(node);
    parent.insertChild(makeIncrement(), index + 1);
  }

  private GlobalStmt makeDeclaration() {
    GlobalStmt decl = new GlobalStmt();
    decl.addName(new Name("g__assignment_count"));
    return decl;
  }

  private AssignStmt makeIncrement() {
    AssignStmt stmt = new AssignStmt(
      new NameExpr(new Name("g__assignment_count")),
      new PlusExpr(
        new NameExpr(new Name("g__assignment_count")),
        new IntLiteralExpr(new DecIntNumericLiteralValue("1"))));
    skip.add(stmt);
    return stmt;
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
}
