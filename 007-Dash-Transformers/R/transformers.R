# library (reticulate)
# library (here)
#  
# #reticulate::py_config()
# 
# reticulate::py_available()
# 
# # Instalar pacotes Python
# 
# #reticulate::py_install ("transformers", pip = TRUE)
# 
# #reticulate::py_install (c("torch", "sentencepiece"), pip = TRUE)
# 
# #text <- ("Dear Amazon, last week I ordered an Optimus Prime action figure from your online store in Germany. Unfortunately, when I opened the package, I discovered to my horror that I had been sent an action figure of Megatron instead! As a lifelong enemy of the Decepticons, I hope you can understand my dilemma. To resolve the issue, I demand an exchange of Megatron for the Optimus Prime figure I ordered. Enclosed are copies of my records concerning this purchase. I expect to hear from you soon. Sincerely, Bumblebee.")
# 
# # Importing 🤗 transformers into R session

Sys.setenv(TOKENIZERS_PARALLELISM="false")

transformers <- reticulate::import("transformers")
# 
# # Instantiate a pipeline

classifier <- transformers$pipeline(task = "text-classification", model = "distilbert-base-uncased-finetuned-sst-2-english")
