function f = minimiseW(w, reconstructionError, TAU, d, i,j)
    f = reconstructionError + TAU*sum((squeeze(d(i,j,:)).*w).^2);
end