import java.util.*;
import ast.Program;
import natlab.*;

import com.google.common.base.Joiner;

public class RoundTrip {
  public static void main(String[] args) {
    // Parse the contents of args[0]
    // (If it doesn't parse, abort)
    Program ast = parseOrDie(args[0]);
    // Pretty print the AST
    System.out.println(ast.getPrettyPrinted());
  }

  private static Program parseOrDie(String path) {
    List<CompilationProblem> errors = new ArrayList<>();
    Program ast = Parse.parseMatlabFile(path, errors);
    if (!errors.isEmpty()) {
      System.err.println("Parse error: " + Joiner.on('\n').join(errors));
      System.exit(1);
    }
    return ast;
  }
}
