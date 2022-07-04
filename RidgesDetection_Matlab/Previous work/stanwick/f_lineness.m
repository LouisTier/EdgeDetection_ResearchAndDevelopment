function result = f_lineness(lambda1, lambda2)

if lambda1 + lambda2 < 0
    result = (lambda1 + lambda2)*(-lambda1/lambda2)
else
    result = 0
end
