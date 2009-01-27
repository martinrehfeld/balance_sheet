namespace :ci do
  task :build => ['db:migrate', :spec]
end