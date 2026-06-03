NAME = ft_turing

SRCS_DIR = srcs
OBJS_DIR = objs

SRCS = \
	$(SRCS_DIR)/types.ml \
	$(SRCS_DIR)/parserFile.ml \
	$(SRCS_DIR)/parserInput.ml \
	$(SRCS_DIR)/printInfo.ml \
	$(SRCS_DIR)/tape.ml \
	$(SRCS_DIR)/transition.ml \
	$(SRCS_DIR)/printer.ml \
	$(SRCS_DIR)/simulator.ml \
	$(SRCS_DIR)/main.ml

PACKAGES   = yojson
OCAMLOPT   = ocamlfind ocamlopt
FLAGS      = -package $(PACKAGES) -linkpkg -I $(SRCS_DIR) -w +a-70

CMXS = $(SRCS:$(SRCS_DIR)/%.ml=$(OBJS_DIR)/%.cmx)

all: check_opam install_deps compil

check_opam:
	@command -v opam >/dev/null 2>&1 || \
		{ echo "Error: opam is not installed."; exit 1; }

install_deps:
	@eval $$(opam env) && \
	for pkg in ocamlfind $(PACKAGES); do \
		opam list --installed $$pkg >/dev/null 2>&1 || \
		opam install -y $$pkg; \
	done

$(OBJS_DIR):
	@mkdir -p $(OBJS_DIR)

$(OBJS_DIR)/%.cmx: $(SRCS_DIR)/%.ml | $(OBJS_DIR)
	@eval $$(opam env) && \
	$(OCAMLOPT) -package $(PACKAGES) -I $(SRCS_DIR) -I $(OBJS_DIR) -c $< -o $@

compil: $(CMXS)
	@eval $$(opam env) && \
	$(OCAMLOPT) $(FLAGS) $(CMXS) -o $(NAME)

run: all
	./$(NAME)
$(OBJS_DIR)/%.cmx: $(SRCS_DIR)/%.ml | $(OBJS_DIR)
	@eval $$(opam env) && \
	$(OCAMLOPT) -package $(PACKAGES) -I $(SRCS_DIR) -I $(OBJS_DIR) -c $< -o $@

compil: $(CMXS)
	@eval $$(opam env) && \
	$(OCAMLOPT) $(FLAGS) $(CMXS) -o $(NAME)

run: all
	./$(NAME)

clean:
	@rm -rf $(OBJS_DIR)
	@rm -rf $(OBJS_DIR)

fclean: clean
	@rm -f $(NAME)
	@rm -f $(NAME)

re: fclean all

.PHONY: all check_opam install_deps compil run clean fclean re
