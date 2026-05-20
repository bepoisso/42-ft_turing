NAME = exec

OCAMLC = ocamlc
SRC = main.ml
OBJ_DIR = obj
OBJ = $(OBJ_DIR)/main.cmo

all: $(NAME)

$(NAME): $(OBJ)
	$(OCAMLC) -o $(NAME) $(OBJ)

$(OBJ_DIR)/main.cmo: main.ml | $(OBJ_DIR)
	$(OCAMLC) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
