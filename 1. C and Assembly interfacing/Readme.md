### C and RISC-V Assembly Interaction

This component focuses on seamless interoperability between C and RISC-V assembly in a bare-metal context. It demonstrates how high-level and low-level code can coordinate for tasks like function calling, string handling, and global data management.

**Key Features:**

- **Bidirectional Function Calls**  
  Implemented function calls from RISC-V assembly to C and vice versa, showcasing ABI compliance and register-based argument passing.

- **Global Variable Sharing**  
  Declared and initialized global variables in the `.data` section from assembly and accessed them within C functions.

- **Formatted Output Handling**  
  Defined an assembly routine `displayStudentProfile` that accepts multiple arguments and prints structured output using values from both C and assembly.

- **Manual String Manipulation in Assembly**  
  Built an assembly function `reverse()` to reverse a given string, store the result in the `.data` section, and return its length to a C caller.

- **C-Assembly Coordination for Output**  
  C driver code passed strings to assembly, invoked the `reverse()` function, and printed both the reversed string and its length.

**Example Output:**

```text
input_string: Hello
reverse_string: olleH, length = 5

